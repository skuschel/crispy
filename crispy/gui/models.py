# coding: utf-8
# /*##########################################################################
#
# Copyright (c) 2016-2018 European Synchrotron Radiation Facility
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#
# ###########################################################################*/

from __future__ import absolute_import, division, unicode_literals

__authors__ = ['Marius Retegan']
__license__ = 'MIT'
__date__ = '17/07/2018'

from collections import OrderedDict as odict

from PyQt5.QtCore import (
    Qt, QAbstractItemModel, QAbstractListModel, QModelIndex, pyqtSignal)


class ResultsModel(QAbstractListModel):
    def __init__(self, parent=None):
        super(ResultsModel, self).__init__(parent=parent)
        self.modelData = list()

    def rowCount(self, parent=QModelIndex()):
        """Return the number of rows in the model."""
        return len(self.modelData)

    def data(self, index, role):
        """Return role specific data for the item referred by the
        index."""
        if not index.isValid():
            return
        row = index.row()
        if role == Qt.DisplayRole or role == Qt.EditRole:
            return self.modelData[row].label

    def setData(self, index, value, role):
        """Set the role data for the item at index to value."""
        if not index.isValid():
            return
        row = index.row()
        if role == Qt.EditRole:
            self.modelData[row].label = value
        self.dataChanged.emit(index, index)
        return True

    def getData(self):
        return self.modelData

    def flags(self, index):
        """Return the active flags for the given index"""
        if not index.isValid():
            return
        activeFlags = (
            Qt.ItemIsEnabled | Qt.ItemIsSelectable | Qt.ItemIsEditable)
        return activeFlags

    def insertItems(self, position, items, parent=QModelIndex()):
        """Insert items at a given position in the model."""
        first = position
        last = position + len(items) - 1
        self.beginInsertRows(QModelIndex(), first, last)
        for item in items:
            self.modelData.insert(position, item)
        self.endInsertRows()
        return True

    def removeItems(self, indexes, parent=QModelIndex()):
        """Remove items from the model."""
        rows = [index.row() for index in indexes]
        first = min(rows)
        last = max(rows)
        self.beginRemoveRows(QModelIndex(), first, last)
        for row in sorted(rows, reverse=True):
            del self.modelData[row]
        self.endRemoveRows()
        return True

    def appendItems(self, items):
        """Insert items at the end of model."""
        position = self.rowCount()
        firstIndex = self.index(position)
        lastIndex = self.index(position + len(items) - 1)
        self.insertItems(position, items)
        self.dataChanged.emit(firstIndex, lastIndex)

    def replaceItem(self, index, item):
        row = index.row()
        self.modelData[row] = item
        self.dataChanged.emit(index, index)

    def getIndexData(self, index):
        """Return the data stored in the model at the given index."""
        if not index.isValid():
            return
        return self.modelData[index.row()]

    def reset(self):
        """Reset the model."""
        self.beginResetModel()
        self.modelData = list()
        self.endResetModel()


class HamiltonianNode(object):
    """Class implementing a tree node to be used in a tree model."""

    def __init__(self, parent=None, nodeData=None):
        self.parent = parent
        self.nodeData = nodeData
        self.children = []
        self.checkState = None

        if parent is not None:
            parent.appendChild(self)

    def appendChild(self, node):
        """Append a child to the parent node."""
        self.children.append(node)

    def getChildren(self):
        return self.children

    def child(self, row):
        """Return the child at a given row."""
        return self.children[row]

    def row(self):
        """Return the row of the child."""
        if self.parent is not None:
            children = self.parent.getChildren()
            # The index method of the list object.
            return children.index(self)
        else:
            return 0

    def childCount(self):
        return len(self.children)

    def columnCount(self):
        return len(self.nodeData)

    def getItemData(self, column):
        """Return the data for a given column."""
        try:
            return self.nodeData[column]
        except IndexError:
            return str()

    def setItemData(self, column, value):
        """Set the data at a given column."""
        try:
            self.nodeData[column] = value
        except IndexError:
            pass

    def getCheckState(self):
        return self.checkState

    def setCheckState(self, checkState):
        self.checkState = checkState


class HamiltonianModel(QAbstractItemModel):
    """Class implementing the Hamiltonian tree model. It subclasses
    QAbstractItemModel and thus implements: index(), parent(),
    rowCount(), columnCount(), and data().

    To enable editing, the class implements setData() and reimplements
    flags() to ensure that an editable item is returned. headerData() is
    also reimplemented to control the way the header is presented.
    """

    nodeCheckStateChanged = pyqtSignal(QModelIndex, Qt.CheckState)

    def __init__(self, parent=None):
        super(HamiltonianModel, self).__init__(parent)
        self.header = ['Parameter', 'Value', 'Scaling']
        self.modelData = odict()

    def index(self, row, column, parentIndex=None):
        """Return the index of the item in the model specified by the
        given row, column, and parent index.
        """
        if parentIndex is None or not parentIndex.isValid():
            parentNode = self.rootNode
        else:
            parentNode = self.getNode(parentIndex)

        childNode = parentNode.child(row)

        if childNode:
            index = self.createIndex(row, column, childNode)
        else:
            index = QModelIndex()

        return index

    def parent(self, childIndex):
        """Return the index of the parent for a given index of the
        child. Unfortunately, the name of the method has to be parent,
        even though a more verbose name like parentIndex, would avoid
        confusion about what parent actually is - an index or an item.
        """
        childNode = self.getNode(childIndex)
        parentNode = childNode.parent

        if parentNode == self.rootNode:
            parentIndex = QModelIndex()
        else:
            parentIndex = self.createIndex(parentNode.row(), 0, parentNode)

        return parentIndex

    def siblings(self, index):
        node = self.getNode(index)

        parentIndex = self.parent(index)
        parentNode = self.getNode(parentIndex)

        siblingIndices = list()
        for child in parentNode.children:
            if child is node:
                continue
            else:
                row = child.row()
                siblingIndex = self.index(row, 0, parentIndex)
                siblingIndices.append(siblingIndex)

        return siblingIndices

    def rowCount(self, parentIndex):
        """Return the number of rows under the given parent. When the
        parentIndex is valid, rowCount() returns the number of children
        of the parent. For this it uses getNode() method to extract the
        parentNode from the parentIndex, and calls the childCount() of
        the node to get number of children.
        """
        if parentIndex.column() > 0:
            return 0

        if not parentIndex.isValid():
            parentNode = self.rootNode
        else:
            parentNode = self.getNode(parentIndex)

        return parentNode.childCount()

    def columnCount(self, parentIndex):
        """Return the number of columns. The index of the parent is
        required, but not used, as in this implementation it defaults
        for all nodes to the length of the header.
        """
        return len(self.header)

    def data(self, index, role):
        """Return role specific data for the item referred by
        index.column()."""
        if not index.isValid():
            return

        node = self.getNode(index)
        column = index.column()
        value = node.getItemData(column)

        if role == Qt.DisplayRole:
            try:
                if column == 1:
                    return '{0:8.3f}'.format(value)
                else:
                    return '{0:8.2f}'.format(value)
            except ValueError:
                return value
        elif role == Qt.EditRole:
            return str(value)
        elif role == Qt.CheckStateRole:
            if node.parent == self.rootNode and column == 0:
                return node.getCheckState()
        elif role == Qt.TextAlignmentRole:
            if column > 0:
                return Qt.AlignRight

    def setData(self, index, value, role):
        """Set the role data for the item at index to value."""
        if not index.isValid():
            return False

        node = self.getNode(index)
        column = index.column()

        if role == Qt.EditRole:
            nodes = list()
            nodes.append(node)

            if self.sync:
                parentIndex = self.parent(index)
                # Iterate over the siblings of the parent index.
                for sibling in self.siblings(parentIndex):
                    siblingNode = self.getNode(sibling)
                    for child in siblingNode.children:
                        if child.getItemData(0) == node.getItemData(0):
                            nodes.append(child)

            for node in nodes:
                columnData = str(node.getItemData(column))
                if columnData and columnData != value:
                    try:
                        node.setItemData(column, float(value))
                    except ValueError:
                        return False
                else:
                    return False

        elif role == Qt.CheckStateRole:
            node.setCheckState(value)
            if value == Qt.Unchecked or value == Qt.Checked:
                state = value
                self.nodeCheckStateChanged.emit(index, state)

        self.dataChanged.emit(index, index)

        return True

    def setSyncState(self, flag):
        self.sync = flag

    def flags(self, index):
        """Return the active flags for the given index. Add editable
        flag to items other than the first column.
        """
        activeFlags = (Qt.ItemIsEnabled | Qt.ItemIsSelectable |
                       Qt.ItemIsUserCheckable)

        node = self.getNode(index)
        column = index.column()

        if column > 0 and not node.childCount():
            activeFlags = activeFlags | Qt.ItemIsEditable

        return activeFlags

    def headerData(self, section, orientation, role):
        """Return the data for the given role and section in the header
        with the specified orientation.
        """
        if orientation == Qt.Horizontal and role == Qt.DisplayRole:
            return self.header[section]

    def getNode(self, index):
        if index is None or not index.isValid():
            return self.rootNode
        return index.internalPointer()

    def setModelData(self, modelData, parentNode=None):
        if parentNode is None:
            self.rootNode = HamiltonianNode(None, self.header)
            parentNode = self.rootNode

        if isinstance(modelData, dict):
            for key, value in modelData.items():
                if isinstance(value, dict):
                    node = HamiltonianNode(parentNode, [key])
                    self.setModelData(value, node)
                elif isinstance(value, float):
                    node = HamiltonianNode(parentNode, [key, value])
                elif isinstance(value, list):
                    node = HamiltonianNode(
                        parentNode, [key, value[0], value[1]])
                else:
                    raise TypeError

    def setHeaderData(self, header):
        self.header = header

    def updateModelData(self, modelData, parentIndex=None):
        parentNode = self.getNode(parentIndex)

        if parentNode.childCount():
            for child in parentNode.children:
                key = child.nodeData[0]
                childData = modelData[key]
                childIndex = self.index(child.row(), 0, parentIndex)
                self.updateModelData(childData, childIndex)
        else:
            if isinstance(modelData, float):
                parentNode.setItemData(1, modelData)
            elif isinstance(modelData, list):
                value, scaling = modelData
                parentNode.setItemData(1, value)
                parentNode.setItemData(2, scaling)
            else:
                raise TypeError
            self.dataChanged.emit(parentIndex, parentIndex)
            return True

    def _getModelData(self, modelData, parentNode=None):
        """Return the data contained in the model."""
        if parentNode is None:
            parentNode = self.rootNode

        for node in parentNode.getChildren():
            key = node.getItemData(0)
            if node.childCount():
                modelData[key] = odict()
                self._getModelData(modelData[key], node)
            else:
                if isinstance(node.getItemData(2), float):
                    modelData[key] = [node.getItemData(1), node.getItemData(2)]
                else:
                    modelData[key] = node.getItemData(1)

    def getModelData(self):
        modelData = odict()
        self._getModelData(modelData)
        return modelData

    def setNodesCheckState(self, checkState, parentNode=None):
        if parentNode is None:
            parentNode = self.rootNode

        children = parentNode.getChildren()

        for child in children:
            childName = child.nodeData[0]
            try:
                child.setCheckState(checkState[childName])
            except KeyError:
                pass

    def getNodesCheckState(self, parentNode=None):
        """Return the check state (disabled, tristate, enable) of all nodes
        belonging to a parent.
        """
        if parentNode is None:
            parentNode = self.rootNode

        checkStates = odict()
        children = parentNode.getChildren()

        for child in children:
            checkStates[child.nodeData[0]] = child.getCheckState()

        return checkStates

    def reset(self):
        self.beginResetModel()
        self.rootNode = None
        self.endResetModel()