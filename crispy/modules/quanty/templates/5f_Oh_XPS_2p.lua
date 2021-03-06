--------------------------------------------------------------------------------
-- Quanty input file generated using Crispy. If you use this file please cite
-- the following reference: http://dx.doi.org/10.5281/zenodo.1008184.
--
-- elements: 5f
-- symmetry: Oh
-- experiment: XPS
-- edge: L2,3 (2p)
--------------------------------------------------------------------------------
Verbosity($Verbosity)

--------------------------------------------------------------------------------
-- Initialize the Hamiltonians.
--------------------------------------------------------------------------------
H_i = 0
H_f = 0

--------------------------------------------------------------------------------
-- Toggle the Hamiltonian terms.
--------------------------------------------------------------------------------
H_atomic = $H_atomic
H_crystal_field = $H_crystal_field
H_5f_ligands_hybridization_lmct = $H_5f_ligands_hybridization_lmct
H_magnetic_field = $H_magnetic_field
H_exchange_field = $H_exchange_field

--------------------------------------------------------------------------------
-- Define the number of electrons, shells, etc.
--------------------------------------------------------------------------------
NBosons = 0
NFermions = 20

NElectrons_2p = 6
NElectrons_5f = $NElectrons_5f

IndexDn_2p = {0, 2, 4}
IndexUp_2p = {1, 3, 5}
IndexDn_5f = {6, 8, 10, 12, 14, 16, 18}
IndexUp_5f = {7, 9, 11, 13, 15, 17, 19}

if H_5f_ligands_hybridization_lmct == 1 then
    NFermions = 34

    NElectrons_L1 = 14

    IndexDn_L1 = {20, 22, 24, 26, 28, 30, 32}
    IndexUp_L1 = {21, 23, 25, 27, 29, 31, 33}
end

--------------------------------------------------------------------------------
-- Define the atomic term.
--------------------------------------------------------------------------------
N_2p = NewOperator('Number', NFermions, IndexUp_2p, IndexUp_2p, {1, 1, 1})
     + NewOperator('Number', NFermions, IndexDn_2p, IndexDn_2p, {1, 1, 1})

N_5f = NewOperator('Number', NFermions, IndexUp_5f, IndexUp_5f, {1, 1, 1, 1, 1, 1, 1})
     + NewOperator('Number', NFermions, IndexDn_5f, IndexDn_5f, {1, 1, 1, 1, 1, 1, 1})

if H_atomic == 1 then
    F0_5f_5f = NewOperator('U', NFermions, IndexUp_5f, IndexDn_5f, {1, 0, 0, 0})
    F2_5f_5f = NewOperator('U', NFermions, IndexUp_5f, IndexDn_5f, {0, 1, 0, 0})
    F4_5f_5f = NewOperator('U', NFermions, IndexUp_5f, IndexDn_5f, {0, 0, 1, 0})
    F6_5f_5f = NewOperator('U', NFermions, IndexUp_5f, IndexDn_5f, {0, 0, 0, 1})

    F0_2p_5f = NewOperator('U', NFermions, IndexUp_2p, IndexDn_2p, IndexUp_5f, IndexDn_5f, {1, 0}, {0, 0})
    F2_2p_5f = NewOperator('U', NFermions, IndexUp_2p, IndexDn_2p, IndexUp_5f, IndexDn_5f, {0, 1}, {0, 0})
    G2_2p_5f = NewOperator('U', NFermions, IndexUp_2p, IndexDn_2p, IndexUp_5f, IndexDn_5f, {0, 0}, {1, 0})
    G4_2p_5f = NewOperator('U', NFermions, IndexUp_2p, IndexDn_2p, IndexUp_5f, IndexDn_5f, {0, 0}, {0, 1})

    U_5f_5f_i = $U(5f,5f)_i_value
    F2_5f_5f_i = $F2(5f,5f)_i_value * $F2(5f,5f)_i_scale
    F4_5f_5f_i = $F4(5f,5f)_i_value * $F4(5f,5f)_i_scale
    F6_5f_5f_i = $F6(5f,5f)_i_value * $F6(5f,5f)_i_scale
    F0_5f_5f_i = U_5f_5f_i + 4 / 195 * F2_5f_5f_i + 2 / 143 * F4_5f_5f_i + 100 / 5577 * F6_5f_5f_i

    U_5f_5f_f = $U(5f,5f)_f_value
    F2_5f_5f_f = $F2(5f,5f)_f_value * $F2(5f,5f)_f_scale
    F4_5f_5f_f = $F4(5f,5f)_f_value * $F4(5f,5f)_f_scale
    F6_5f_5f_f = $F6(5f,5f)_f_value * $F6(5f,5f)_f_scale
    F0_5f_5f_f = U_5f_5f_f + 4 / 195 * F2_5f_5f_f + 2 / 143 * F4_5f_5f_f + 100 / 5577 * F6_5f_5f_f
    U_2p_5f_f = $U(2p,5f)_f_value
    F2_2p_5f_f = $F2(2p,5f)_f_value * $F2(2p,5f)_f_scale
    G2_2p_5f_f = $G2(2p,5f)_f_value * $G2(2p,5f)_f_scale
    G4_2p_5f_f = $G4(2p,5f)_f_value * $G4(2p,5f)_f_scale
    F0_2p_5f_f = U_2p_5f_f + 3 / 70 * G2_2p_5f_f + 2 / 63 * G4_2p_5f_f

    H_i = H_i + Chop(
          F0_5f_5f_i * F0_5f_5f
        + F2_5f_5f_i * F2_5f_5f
        + F4_5f_5f_i * F4_5f_5f
        + F6_5f_5f_i * F6_5f_5f)

    H_f = H_f + Chop(
          F0_5f_5f_f * F0_5f_5f
        + F2_5f_5f_f * F2_5f_5f
        + F4_5f_5f_f * F4_5f_5f
        + F6_5f_5f_f * F6_5f_5f
        + F0_2p_5f_f * F0_2p_5f
        + F2_2p_5f_f * F2_2p_5f
        + G2_2p_5f_f * G2_2p_5f
        + G4_2p_5f_f * G4_2p_5f)

    ldots_5f = NewOperator('ldots', NFermions, IndexUp_5f, IndexDn_5f)

    ldots_2p = NewOperator('ldots', NFermions, IndexUp_2p, IndexDn_2p)

    zeta_5f_i = $zeta(5f)_i_value * $zeta(5f)_i_scale

    zeta_5f_f = $zeta(5f)_f_value * $zeta(5f)_f_scale
    zeta_2p_f = $zeta(2p)_f_value * $zeta(2p)_f_scale

    H_i = H_i + Chop(
          zeta_5f_i * ldots_5f)

    H_f = H_f + Chop(
          zeta_5f_f * ldots_5f
        + zeta_2p_f * ldots_2p)
end

--------------------------------------------------------------------------------
-- Define the crystal field term.
--------------------------------------------------------------------------------
if H_crystal_field == 1 then
    -- PotentialExpandedOnClm('Oh', 3, {Ea2u, Et1u, Et2u})
    -- Ea2u_5f = NewOperator('CF', NFermions, IndexUp_5f, IndexDn_5f, PotentialExpandedOnClm('Oh', 3, {1, 0, 0}))
    -- Et2u_5f = NewOperator('CF', NFermions, IndexUp_5f, IndexDn_5f, PotentialExpandedOnClm('Oh', 3, {0, 1, 0}))
    -- Et1u_5f = NewOperator('CF', NFermions, IndexUp_5f, IndexDn_5f, PotentialExpandedOnClm('Oh', 3, {0, 0, 1}))

    B40_5f_i = $B40(5f)_i_value
    B60_5f_i = $B60(5f)_i_value

    Akm_5f_i = {
        {4,  0, B40_5f_i},
        {4, -4, math.sqrt(5/14) * B40_5f_i},
        {4,  4, math.sqrt(5/14) * B40_5f_i},
        {6,  0, B60_5f_i},
        {6, -4, -math.sqrt(7/2) * B60_5f_i},
        {6,  4, -math.sqrt(7/2) * B60_5f_i},
    }

    io.write('Energies of the 5f orbitals in the initial Hamiltonian (crystal field term only):\n')
    io.write('================\n')
    io.write('Irrep.        E\n')
    io.write('================\n')
    io.write(string.format('a2u     %8.3f\n', -4 / 11 * B40_5f_i +  80 / 143 * B60_5f_i))
    io.write(string.format('t1u     %8.3f\n',  2 / 11 * B40_5f_i + 100 / 429 * B60_5f_i))
    io.write(string.format('t2u     %8.3f\n', -2 / 33 * B40_5f_i -  60 / 143 * B60_5f_i))
    io.write('================\n')
    io.write('\n')

    B40_5f_f = $B40(5f)_f_value
    B60_5f_f = $B60(5f)_f_value

    Akm_5f_f = {
        {4,  0, B40_5f_f},
        {4, -4, math.sqrt(5/14) * B40_5f_f},
        {4,  4, math.sqrt(5/14) * B40_5f_f},
        {6,  0, B60_5f_f},
        {6, -4, -math.sqrt(7/2) * B60_5f_f},
        {6,  4, -math.sqrt(7/2) * B60_5f_f},
    }

    H_i = H_i + Chop(NewOperator('CF', NFermions, IndexUp_5f, IndexDn_5f, Akm_5f_i))

    H_f = H_f + Chop(NewOperator('CF', NFermions, IndexUp_5f, IndexDn_5f, Akm_5f_f))
end

--------------------------------------------------------------------------------
-- Define the 5f-ligands hybridization term.
--------------------------------------------------------------------------------
if H_5f_ligands_hybridization_lmct == 1 then
    N_L1 = NewOperator('Number', NFermions, IndexUp_L1, IndexUp_L1, {1, 1, 1, 1, 1, 1, 1})
         + NewOperator('Number', NFermions, IndexDn_L1, IndexDn_L1, {1, 1, 1, 1, 1, 1, 1})

    Delta_5f_L1_i = $Delta(5f,L1)_i_value
    e_5f_i = (28 * Delta_5f_L1_i - 27 * U_5f_5f_i * NElectrons_5f - U_5f_5f_i * NElectrons_5f^2) / (2 * (14 + NElectrons_5f))
    e_L1_i = NElectrons_5f * (-2 * Delta_5f_L1_i + U_5f_5f_i * NElectrons_5f + U_5f_5f_i) / (2 * (NElectrons_5f + 14))

    Delta_5f_L1_f = $Delta(5f,L1)_f_value
    e_5f_f = (28 * Delta_5f_L1_f - U_5f_5f_f * NElectrons_5f^2 - 39 * U_5f_5f_f * NElectrons_5f - 228 * U_2p_5f_f) / (2 * (NElectrons_5f + 20))
    e_2p_f = (28 * Delta_5f_L1_f + U_5f_5f_f * NElectrons_5f^2 + U_5f_5f_f * NElectrons_5f - 2 * U_2p_5f_f * NElectrons_5f^2 - 30 * U_2p_5f_f * NElectrons_5f - 28 * U_2p_5f_f) / (2 * (NElectrons_5f + 20))
    e_L1_f = (-2 * Delta_5f_L1_f * NElectrons_5f - 12 * Delta_5f_L1_f + U_5f_5f_f * NElectrons_5f^2 + U_5f_5f_f * NElectrons_5f + 12 * U_2p_5f_f * NElectrons_5f + 12 * U_2p_5f_f) / (2 * (NElectrons_5f + 20))

    H_i = H_i + Chop(
          e_5f_i * N_5f
        + e_L1_i * N_L1)

    H_f = H_f + Chop(
          e_5f_f * N_5f
        + e_2p_f * N_2p
        + e_L1_f * N_L1)

    B40_L1_i = $B40(L1)_i_value
    B60_L1_i = $B60(L1)_i_value

    Akm_L1_i = {
        {4,  0, B40_L1_i},
        {4, -4, math.sqrt(5/14) * B40_L1_i},
        {4,  4, math.sqrt(5/14) * B40_L1_i},
        {6,  0, B60_L1_i},
        {6, -4, -math.sqrt(7/2) * B60_L1_i},
        {6,  4, -math.sqrt(7/2) * B60_L1_i},
    }

    H_i = H_i + Chop(NewOperator('CF', NFermions, IndexUp_L1, IndexDn_L1, Akm_L1_i))

    B40_L1_f = $B40(L1)_f_value
    B60_L1_f = $B60(L1)_f_value

    Akm_L1_f = {
        {4,  0, B40_L1_f},
        {4, -4, math.sqrt(5/14) * B40_L1_f},
        {4,  4, math.sqrt(5/14) * B40_L1_f},
        {6,  0, B60_L1_f},
        {6, -4, -math.sqrt(7/2) * B60_L1_f},
        {6,  4, -math.sqrt(7/2) * B60_L1_f},
    }

    H_f = H_f + Chop(NewOperator('CF', NFermions, IndexUp_L1, IndexDn_L1, Akm_L1_f))

    -- Mixing of the f-orbitals with the ligands.
    Va2u_5f_L1 = NewOperator('CF', NFermions, IndexUp_L1, IndexDn_L1, IndexUp_5f, IndexDn_5f, PotentialExpandedOnClm('Oh', 3, {1, 0, 0}))
               + NewOperator('CF', NFermions, IndexUp_5f, IndexDn_5f, IndexUp_L1, IndexDn_L1, PotentialExpandedOnClm('Oh', 3, {1, 0, 0}))

    Vt2u_5f_L1 = NewOperator('CF', NFermions, IndexUp_L1, IndexDn_L1, IndexUp_5f, IndexDn_5f, PotentialExpandedOnClm('Oh', 3, {0, 1, 0}))
               + NewOperator('CF', NFermions, IndexUp_5f, IndexDn_5f, IndexUp_L1, IndexDn_L1, PotentialExpandedOnClm('Oh', 3, {0, 1, 0}))

    Vt1u_5f_L1 = NewOperator('CF', NFermions, IndexUp_L1, IndexDn_L1, IndexUp_5f, IndexDn_5f, PotentialExpandedOnClm('Oh', 3, {0, 0, 1}))
               + NewOperator('CF', NFermions, IndexUp_5f, IndexDn_5f, IndexUp_L1, IndexDn_L1, PotentialExpandedOnClm('Oh', 3, {0, 0, 1}))

    Va2u_5f_L1_i = $Va2u(5f,L1)_i_value
    Vt2u_5f_L1_i = $Vt2u(5f,L1)_i_value
    Vt1u_5f_L1_i = $Vt1u(5f,L1)_i_value

    Va2u_5f_L1_f = $Va2u(5f,L1)_f_value
    Vt2u_5f_L1_f = $Vt2u(5f,L1)_f_value
    Vt1u_5f_L1_f = $Vt1u(5f,L1)_f_value

    H_i = H_i + Chop(
        Va2u_5f_L1_i * Va2u_5f_L1
      + Vt2u_5f_L1_i * Vt2u_5f_L1
      + Vt1u_5f_L1_i * Vt1u_5f_L1)

    H_f = H_f + Chop(
        Va2u_5f_L1_f * Va2u_5f_L1
      + Vt2u_5f_L1_f * Vt2u_5f_L1
      + Vt1u_5f_L1_f * Vt1u_5f_L1)
end

--------------------------------------------------------------------------------
-- Define the magnetic field and exchange field terms.
--------------------------------------------------------------------------------
Sx_5f = NewOperator('Sx', NFermions, IndexUp_5f, IndexDn_5f)
Sy_5f = NewOperator('Sy', NFermions, IndexUp_5f, IndexDn_5f)
Sz_5f = NewOperator('Sz', NFermions, IndexUp_5f, IndexDn_5f)
Ssqr_5f = NewOperator('Ssqr', NFermions, IndexUp_5f, IndexDn_5f)
Splus_5f = NewOperator('Splus', NFermions, IndexUp_5f, IndexDn_5f)
Smin_5f = NewOperator('Smin', NFermions, IndexUp_5f, IndexDn_5f)

Lx_5f = NewOperator('Lx', NFermions, IndexUp_5f, IndexDn_5f)
Ly_5f = NewOperator('Ly', NFermions, IndexUp_5f, IndexDn_5f)
Lz_5f = NewOperator('Lz', NFermions, IndexUp_5f, IndexDn_5f)
Lsqr_5f = NewOperator('Lsqr', NFermions, IndexUp_5f, IndexDn_5f)
Lplus_5f = NewOperator('Lplus', NFermions, IndexUp_5f, IndexDn_5f)
Lmin_5f = NewOperator('Lmin', NFermions, IndexUp_5f, IndexDn_5f)

Jx_5f = NewOperator('Jx', NFermions, IndexUp_5f, IndexDn_5f)
Jy_5f = NewOperator('Jy', NFermions, IndexUp_5f, IndexDn_5f)
Jz_5f = NewOperator('Jz', NFermions, IndexUp_5f, IndexDn_5f)
Jsqr_5f = NewOperator('Jsqr', NFermions, IndexUp_5f, IndexDn_5f)
Jplus_5f = NewOperator('Jplus', NFermions, IndexUp_5f, IndexDn_5f)
Jmin_5f = NewOperator('Jmin', NFermions, IndexUp_5f, IndexDn_5f)

Tx_5f = NewOperator('Tx', NFermions, IndexUp_5f, IndexDn_5f)
Ty_5f = NewOperator('Ty', NFermions, IndexUp_5f, IndexDn_5f)
Tz_5f = NewOperator('Tz', NFermions, IndexUp_5f, IndexDn_5f)

Sx = Sx_5f
Sy = Sy_5f
Sz = Sz_5f

Lx = Lx_5f
Ly = Ly_5f
Lz = Lz_5f

Jx = Jx_5f
Jy = Jy_5f
Jz = Jz_5f

Tx = Tx_5f
Ty = Ty_5f
Tz = Tz_5f

Ssqr = Sx * Sx + Sy * Sy + Sz * Sz
Lsqr = Lx * Lx + Ly * Ly + Lz * Lz
Jsqr = Jx * Jx + Jy * Jy + Jz * Jz

if H_magnetic_field == 1 then
    Bx_i = $Bx_i_value
    By_i = $By_i_value
    Bz_i = $Bz_i_value

    Bx_f = $Bx_f_value
    By_f = $By_f_value
    Bz_f = $Bz_f_value

    H_i = H_i + Chop(
          Bx_i * (2 * Sx + Lx)
        + By_i * (2 * Sy + Ly)
        + Bz_i * (2 * Sz + Lz))

    H_f = H_f + Chop(
          Bx_f * (2 * Sx + Lx)
        + By_f * (2 * Sy + Ly)
        + Bz_f * (2 * Sz + Lz))
end

if H_exchange_field == 1 then
    Hx_i = $Hx_i_value
    Hy_i = $Hy_i_value
    Hz_i = $Hz_i_value

    Hx_f = $Hx_f_value
    Hy_f = $Hy_f_value
    Hz_f = $Hz_f_value

    H_i = H_i + Chop(
          Hx_i * Sx
        + Hy_i * Sy
        + Hz_i * Sz)

    H_f = H_f + Chop(
          Hx_f * Sx
        + Hy_f * Sy
        + Hz_f * Sz)
end

NConfigurations = $NConfigurations

--------------------------------------------------------------------------------
-- Define the restrictions and set the number of initial states.
--------------------------------------------------------------------------------
InitialRestrictions = {NFermions, NBosons, {'111111 00000000000000', NElectrons_2p, NElectrons_2p},
                                           {'000000 11111111111111', NElectrons_5f, NElectrons_5f}}

FinalRestrictions = {NFermions, NBosons, {'111111 00000000000000', NElectrons_2p - 1, NElectrons_2p - 1},
                                         {'000000 11111111111111', NElectrons_5f + 1, NElectrons_5f + 1}}

if H_5f_ligands_hybridization_lmct == 1 then
    InitialRestrictions = {NFermions, NBosons, {'111111 00000000000000 00000000000000', NElectrons_2p, NElectrons_2p},
                                               {'000000 11111111111111 00000000000000', NElectrons_5f, NElectrons_5f},
                                               {'000000 00000000000000 11111111111111', NElectrons_L1, NElectrons_L1}}

    FinalRestrictions = {NFermions, NBosons, {'111111 00000000000000 00000000000000', NElectrons_2p - 1, NElectrons_2p - 1},
                                             {'000000 11111111111111 00000000000000', NElectrons_5f + 1, NElectrons_5f + 1},
                                             {'000000 00000000000000 11111111111111', NElectrons_L1, NElectrons_L1}}

    CalculationRestrictions = {NFermions, NBosons, {'000000 00000000000000 11111111111111', NElectrons_L1 - (NConfigurations - 1), NElectrons_L1}}
end

T = $T * EnergyUnits.Kelvin.value

-- Approximate machine epsilon for single precision arithmetics.
epsilon = 1.19e-07

NPsis = $NPsis
NPsisAuto = $NPsisAuto

dZ = {}

if NPsisAuto == 1 and NPsis ~= 1 then
    NPsis = 4
    NPsisIncrement = 8
    NPsisIsConverged = false

    while not NPsisIsConverged do
        if CalculationRestrictions == nil then
            Psis_i = Eigensystem(H_i, InitialRestrictions, NPsis)
        else
            Psis_i = Eigensystem(H_i, InitialRestrictions, NPsis, {{'restrictions', CalculationRestrictions}})
        end

        if not (type(Psis_i) == 'table') then
            Psis_i = {Psis_i}
        end

        E_gs_i = Psis_i[1] * H_i * Psis_i[1]

        Z = 0

        for i, Psi in ipairs(Psis_i) do
            E = Psi * H_i * Psi

            if math.abs(E - E_gs_i) < epsilon then
                dZ[i] = 1
            else
                dZ[i] = math.exp(-(E - E_gs_i) / T)
            end

            Z = Z + dZ[i]

            if (dZ[i] / Z) < math.sqrt(epsilon) then
                i = i - 1
                NPsisIsConverged = true
                NPsis = i
                Psis_i = {unpack(Psis_i, 1, i)}
                dZ = {unpack(dZ, 1, i)}
                break
            end
        end

        if NPsisIsConverged then
            break
        else
            NPsis = NPsis + NPsisIncrement
        end
    end
else
    if CalculationRestrictions == nil then
        Psis_i = Eigensystem(H_i, InitialRestrictions, NPsis)
    else
        Psis_i = Eigensystem(H_i, InitialRestrictions, NPsis, {{'restrictions', CalculationRestrictions}})
    end

    if not (type(Psis_i) == 'table') then
        Psis_i = {Psis_i}
    end
        E_gs_i = Psis_i[1] * H_i * Psis_i[1]

    Z = 0

    for i, Psi in ipairs(Psis_i) do
        E = Psi * H_i * Psi

        if math.abs(E - E_gs_i) < epsilon then
            dZ[i] = 1
        else
            dZ[i] = math.exp(-(E - E_gs_i) / T)
        end

        Z = Z + dZ[i]
    end
end

-- Normalize dZ to unity.
for i in ipairs(dZ) do
    dZ[i] = dZ[i] / Z
end

--------------------------------------------------------------------------------
-- Define some helper function for the spectra calculation.
--------------------------------------------------------------------------------
function ValueInTable(value, table)
    -- Check if a value is in a table.
    for k, v in ipairs(table) do
        if value == v then
            return true
        end
    end
    return false
end

function GetSpectrum(G, T, Psis, indices, dZSpectra)
    -- Extract the spectra corresponding to the operators identified
    -- using the indices argument. The returned spectrum is a weighted
    -- sum, where the weights are the Boltzmann probabilities.
    if not (type(indices) == 'table') then
        indices = {indices}
    end

    c = 1
    dZSpectrum = {}

    for i in ipairs(T) do
        for k in ipairs(Psis) do
            if ValueInTable(i, indices) then
                table.insert(dZSpectrum, dZSpectra[c])
            else
                table.insert(dZSpectrum, 0)
            end
            c = c + 1
        end
    end

    return Spectra.Sum(G, dZSpectrum)
end

function SaveSpectrum(G, suffix)
    -- Scale, broaden, and save the spectrum to disk.
    G = -1 / math.pi * G

    Gmin1 = $Gmin1 - Gamma
    Gmax1 = $Gmax1 - Gamma
    Egamma1 = ($Egamma1 - Eedge1) + DeltaE
    G.Broaden(0, {{Emin, Gmin1}, {Egamma1, Gmin1}, {Egamma1, Gmax1}, {Emax, Gmax1}})

    G.Print({{'file', '$BaseName_' .. suffix .. '.spec'}})
end

--------------------------------------------------------------------------------
-- Define the transition operators.
--------------------------------------------------------------------------------
T_2p = {}
for i = 1, NElectrons_2p / 2 do
    T_2p[2*i - 1] = NewOperator('An', NFermions, IndexDn_2p[i])
    T_2p[2*i]     = NewOperator('An', NFermions, IndexUp_2p[i])
end

k = $k1

-- List with the user selected spectra.
spectra = {$spectra}

indices_2p = {}
c = 1

spectrum = 'Isotropic'
if ValueInTable(spectrum, spectra) then
    indices_2p[spectrum] = {}
    for j, operator in ipairs(T_2p) do
        table.insert(indices_2p[spectrum], c)
        c = c + 1
    end
end

--------------------------------------------------------------------------------
-- Calculate and save the spectra.
--------------------------------------------------------------------------------
Sk = Chop(k[1] * Sx + k[2] * Sy + k[3] * Sz)
Lk = Chop(k[1] * Lx + k[2] * Ly + k[3] * Lz)
Jk = Chop(k[1] * Jx + k[2] * Jy + k[3] * Jz)
Tk = Chop(k[1] * Tx + k[2] * Ty + k[3] * Tz)

Operators = {H_i, Ssqr, Lsqr, Jsqr, Sk, Lk, Jk, Tk, ldots_5f, N_2p, N_5f, 'dZ'}
header = 'Analysis of the initial Hamiltonian:\n'
header = header .. '=================================================================================================================================\n'
header = header .. 'State         <E>     <S^2>     <L^2>     <J^2>      <Sk>      <Lk>      <Jk>      <Tk>     <l.s>    <N_2p>    <N_5f>          dZ\n'
header = header .. '=================================================================================================================================\n'
footer = '=================================================================================================================================\n'

if H_5f_ligands_hybridization_lmct == 1 then
    Operators = {H_i, Ssqr, Lsqr, Jsqr, Sk, Lk, Jk, Tk, ldots_5f, N_2p, N_5f, N_L1, 'dZ'}
    header = 'Analysis of the initial Hamiltonian:\n'
    header = header .. '===========================================================================================================================================\n'
    header = header .. 'State         <E>     <S^2>     <L^2>     <J^2>      <Sk>      <Lk>      <Jk>      <Tk>     <l.s>    <N_2p>    <N_5f>    <N_L1>          dZ\n'
    header = header .. '===========================================================================================================================================\n'
    footer = '===========================================================================================================================================\n'
end

io.write(header)
for i, Psi in ipairs(Psis_i) do
    io.write(string.format('%5d', i))
    for j, Operator in ipairs(Operators) do
        if j == 1 then
            io.write(string.format('%12.6f', Complex.Re(Psi * Operator * Psi)))
        elseif Operator == 'dZ' then
            io.write(string.format('%12.2E', dZ[i]))
        else
            io.write(string.format('%10.4f', Complex.Re(Psi * Operator * Psi)))
        end
    end
    io.write('\n')
end
io.write(footer)


if next(spectra) == nil then
    return
end

E_gs_i = Psis_i[1] * H_i * Psis_i[1]

if CalculationRestrictions == nil then
    Psis_f = Eigensystem(H_f, FinalRestrictions, 1)
else
    Psis_f = Eigensystem(H_f, FinalRestrictions, 1, {{'restrictions', CalculationRestrictions}})
end

Psis_f = {Psis_f}
E_gs_f = Psis_f[1] * H_f * Psis_f[1]

Eedge1 = $Eedge1
DeltaE = E_gs_f - E_gs_i

Emin = ($Emin1 - Eedge1) + DeltaE
Emax = ($Emax1 - Eedge1) + DeltaE
NE = $NE1
Gamma = $Gamma1
DenseBorder = $DenseBorder

if CalculationRestrictions == nil then
    G_2p = CreateSpectra(H_f, T_2p, Psis_i, {{'Emin', Emin}, {'Emax', Emax}, {'NE', NE}, {'Gamma', Gamma}, {'DenseBorder', DenseBorder}})
else
    G_2p = CreateSpectra(H_f, T_2p, Psis_i, {{'Emin', Emin}, {'Emax', Emax}, {'NE', NE}, {'Gamma', Gamma}, {'restrictions', CalculationRestrictions}, {'DenseBorder', DenseBorder}})
end

-- Create a list with the Boltzmann probabilities for a given operator
-- and state.
dZ_2p = {}
for i in ipairs(T_2p) do
    for j in ipairs(Psis_i) do
        table.insert(dZ_2p, dZ[j])
    end
end

spectrum = 'Isotropic'
if ValueInTable(spectrum, spectra) then
    Giso = GetSpectrum(G_2p, T_2p, Psis_i, indices_2p[spectrum], dZ_2p)
    SaveSpectrum(Giso / #T_2p, 'iso')
end

