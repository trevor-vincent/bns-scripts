#!/usr/bin/env python3
import numpy as np
from scipy.optimize import fsolve
'''

Configuration

chi_BH = Dimensionless BH Spin
inc_BH = Inlcination angle between BH spin and orbital ang. mom.
M_BH = Christidoulou BH Mass (M_sun)

'''

chi_BH=0.9
inc_BH=0
M_BH=7

'''

You shouldn't need to edit anything below

'''

# arxiv:1601.07711
# (multiply by M_BH to get results in M_sun)
def ISCO_R(chi):
    Z1 = 1. + (1.-chi**2.)**(1./3.) * ( (1.+chi)**(1./3.) + (1.-chi)**(1./3.) )
    Z2 = np.sqrt(3*chi**2. + Z1**2.)
    return 3. + Z2 - np.sign(chi) * np.sqrt( (3.-Z1)*(3.+Z1+2.*Z2) )
# arxiv:1601.07711
def binding_energy(M_NS, M_b):
    return 1. - M_NS/M_b
# arxiv:1109.3402
def tidal_parameter(k_2,C_NS):
    return 2./3. * k_2 / C_NS**5

# Stone et al arxiv:1209.4097v2
def ISSO_Z(r, chi):
    return (  (r*(r-6))**2 
             - chi**2*( 2*r*(3*r+14) - 9*chi**2 )  )
def ISSO_P(r, chi):
    return (  r**3*( r**2*(r-6) + chi**2*(3*r+4) ) 
            + chi**4*( 3*r*(r-2)+chi**2 )  )
def ISSO_X(r, chi):
    return (  chi**2
            * ( chi**2*(3*chi**2 + 4*r*(2*r-3))
              + r**2*(15*r*(r-4) +28) )
            - 6*r**4*(r**2-4)  )
def ISSO_Y(r, chi):
    return (  chi**4*( chi**4 + r**2*(7.*r*(3*r-4.) + 36.) )
            + 6.*r*(r-2.)
            * ( chi**6 + 2.*r**3*(chi**2*(3*r+2.) + 3.*r**2*(r-2.)) )  )
def ISSO_S(r, chi, inc):
    C = np.cos(np.radians(inc))
    return (  r**8.*ISSO_Z(r, chi) 
              + chi**2.*(1-C**2)*( chi**2.*(1-C**2)*ISSO_Y(r, chi)
              - 2.*r**4*ISSO_X(r, chi) )  )

# Basic bisection method to solve for the roots of the ISSO
# - finds the root of the located between the ISCO and ISSO_S
def ISSO_R(chi, inc):
    EPS=1.e-11

    # 1. find the polar (inc=+-pi/2) ISSO
    rl = 1. + np.sqrt(3) + np.sqrt( 3 + 2*np.sqrt(3) )
    rr = 6.

    pl = ISSO_P(rl, chi)
    pr = ISSO_P(rr, chi)

    if pl*pr >= 0.:
        if abs(pl) < EPS:
            PISSO=rl
        else:
            if abs(pr) < EPS:
                p_isso=rr;
            else:
                print("ERROR: couldn't find root for polar ISSO for chi = ", chi)
                print("pl, pr = ", pl, ",", pr)
                return 0.
    else:
        while rr-rl > 1.e-4:
            rave = 0.5*(rr + rl)
            pave = ISSO_P(rave, chi)
            if abs(pave) < EPS:
                rr = rl = rave
            else:
                if pr*pave < 0:
                    rl = rave
                    pl = pave
                else:
                    rr = rave
                    pr = pave
        p_isso=rave


    # 2. if no inclination to the spin, we're done
    C = np.cos(np.radians(inc))
    if abs(C) < EPS:
        return p_isso

    # 3. decide if prograde or retrograde orbit
    if C < 0.:
        rl = p_isso
        rr = 9.
    else:
        rl = 1.
        rr = p_isso

    # 4. finally, find the root lying between the generic ISSO root
    #    and the polar ISSO root
    sl = ISSO_S(rl, chi, inc)
    sr = ISSO_S(rr, chi, inc)

    if sl*sr >= 0.:
        if abs(sl)<EPS:
            return rl
        if abs(sr)<EPS:
            return rr
        print("ERROR: couldn't find root for chi_BH = ", chi, "theta = ", inc)
        print("rl, rr = ", rl, rr)
        print("sl, sr = ", sl, sr)
        return 0.
    else:
        while rr-rl > 1e-2:
            if abs(sl) < EPS:
                return rl
            if abs(sr) < EPS:
                return rr
            rave = 0.5*(rl+rr)
            save = ISSO_S(rave, chi, inc)
            if save*sr < 0.:
                rl = rave
                sl = save
            else:
                rr = rave
                sr = save
        return rave

# arxiv:1601.07711v2 
# (multiply by M_b to get results in M_sun)
def ejecta_mass_fit_kk_v2(Q, C_NS, r_isco, E_b):
    a1 = 8.071e-02
    a2 = 2.921e-03
    a3 = 4.419
    a4 =-7.537e-01
    n1 = 1.629e-01
    n2 = 1.282
    b  = 1.700e-02

    m1 = a1*Q**n1 * (1. - 2.*C_NS)/C_NS
    m2 = -a2*Q**n2*r_isco
    m3 = a3*E_b
    m4 = a4

    def slope(x, b):
        if x > b:
            return x
        else:
            return b*np.exp((x-b)/b)
 
    return slope(m1+m2+m3+m4,b)

# arxiv:1601.07711v3 
# (multiply by M_b to get results in M_sun)
def ejecta_mass_fit_kk_v3(Q, C_NS, r_isco, E_b):
    a1 = 4.464e-02
    a2 = 2.269e-03
    a3 = 2.431
    a4 =-4.159e-01
    n1 = 2.497e-01
    n2 = 1.352

    m1 = a1*Q**n1 * (1. - 2.*C_NS)/C_NS
    m2 = -a2*Q**n2*r_isco
    m3 = a3*E_b
    m4 = a4

    return np.maximum(m1+m2+m3+m4,0.)

# arxiv:1207.6304
# (multiply by M_b to get results in M_sun)
def disk_mass_fit_ff(Q, C_NS, R_isco, R_NS):
    alpha = 0.288
    beta = 0.148
    #alpha=0.296
    #beta=0.171

    m1 = alpha*(3.*Q)**(1./3.)*(1. - 2.*C_NS)
    m2 = -beta*R_isco / R_NS

    return np.maximum(m1+m2,0)

# BH predictions for the final spin and mass of the black hole
# arxiv:1311.5931
def symmetric_mass_ratio(M_BH, M_NS):
    return M_BH*M_NS/(M_BH + M_NS)**2

def transition_function(nu):
    if nu <= 0.16:
        return 0
    elif nu > 0.16 and nu < 2./9.:
        f_0=np.cos(np.pi*(nu-0.16)/(2./9. - 0.16))
        return 0.5(1-f_0)
    elif nu >= 2./9. and nu <= 0.25:
        return 1

def orbital_energy(r, chi, inc):
    num = r**2 - 2*r + np.sign(chi)*chi*np.sqrt(r)
    den = r*np.sqrt( r**2 - 3*r + np.sign(chi)*2*chi*np.sqrt(r) )
    return num/den

def orbital_momentum(r, chi, inc):
    num = r**2 - np.sign(chi)*2*chi_BH*np.sqrt(r) + chi**2
    den = np.sqrt(r)*np.sqrt( r**2 - 3*r + np.sign(chi)*2*chi*np.sqrt(r) )
    return np.sign(chi)*num/den

def bh_mass_final(id, r_i, chi_i, inc_i, r_f, chi_f, inc_f):
    M_NS,R_NS,C_NS,M_b,Q,M_BH=id
    nu  = symmetric_mass_ratio(M_BH, M_NS)
    f_nu = transition_function(nu)

    M_disk = M_b*disk_mass_fit_ff(Q, C_NS, r_i*M_BH, R_NS)

    m_bh_f = (M_BH + M_NS)*(1 - (1 - orbital_energy(r_i, chi_i, inc_i))*nu)
    m_bh_f-= M_disk*orbital_energy(r_f, chi_f, inc_f)

    return m_bh_f

def spin_function(id, r_i, chi_i, inc_i, r, chi, inc):
    M_NS,R_NS,C_NS,M_b,Q,M_BH=id
    nu  = symmetric_mass_ratio(M_BH, M_NS)
    f_nu = transition_function(nu)
    M_disk = M_b*disk_mass_fit_ff(Q, C_NS, r_i*M_BH, R_NS)

    c_1 = chi_i*M_BH**2
    c_2 = M_BH*( M_NS*(1-f_nu) + f_nu*M_b - M_disk )
    c_3 = (M_BH+M_NS)*( 1 - (1-orbital_energy(r_i, chi_i, inc_i))*nu )
    c_4 = -M_disk

    def Q_spin(r, chi):
        return np.sqrt( r**2 - 3*r + 2*np.sign(chi)*chi*np.sqrt(r) )

    return ( c_1*r**2*Q_spin(r, chi)**2
           + c_2*r**(1.5)*Q_spin(r, chi)
             * np.sign(chi)*( r**2 - np.sign(chi)*2*chi*np.sqrt(r) + chi**2 )
           - c_3**2*chi*r**2*Q_spin(r, chi)**2
           - c_4**2*chi
             * ( r**2 - 2*r + np.sign(chi)*chi*np.sqrt(r) )**2
           - 2*c_3*c_4*chi*r*Q_spin(r, chi)
             * ( r**2 - 2*r + np.sign(chi)*chi*np.sqrt(r) )
           )

def spin_final(id, r_i, chi_i, inc_i):
    # these quantities don't change
    M_NS,R_NS,C_NS,M_b,Q,M_BH=id

    nu  = symmetric_mass_ratio(M_BH, M_NS)
    f_nu = transition_function(nu)

    M_disk = M_b*disk_mass_fit_ff(Q, C_NS, r_i*M_BH, R_NS)

    inc = inc_i

    # root find
    EPS=1e-11
    TOL=1e-4
    chil = 0.5*chi_i 
    chir = 1-TOL

    rl = ISSO_R(chil, inc)
    rr = ISSO_R(chir, inc)

    fl = spin_function(id, r_i, chi_i, inc_i, rl, chil, inc)
    fr = spin_function(id, r_i, chi_i, inc_i, rr, chir, inc)

    if fl*fr >= 0.:
        if abs(fl) < EPS:
            chi_f=fl
        else:
            if abs(fr) < EPS:
                chi_f=fr;
            else:
                print("ERROR: couldn't find root for final spin")
                print("fl, fr = ", fl, ",", fr)
                return 0.
    else:
        while chir-chil > TOL:
            chiave = 0.5*(chir + chil)
            rave = ISSO_R(chiave, inc)
            fave = spin_function(id, r_i, chi_i, inc_i, rave, chiave, inc)

            if abs(fave) < EPS:
                chir = chil = chiave
            else:
                if fr*fave < 0:
                    chil = chiave
                    rl = rave
                    fl = fave
                else:
                    chir = chiave
                    rr = rave
                    fr = fave

        r_f = ISSO_R(chiave, inc)
        chi_f = chiave
        inc_f = inc

    M_BH_f = bh_mass_final(id, r_i, chi_i, inc_i, r_f, chi_f, inc_f)

    return chi_f, M_BH_f, inc_f

# Begin working on case the requires inclination!=0
def spin_equations(p):
    chi_f, inc_f = p
#    print("chi_f, inc_f = ", chi_f, inc_f)
    r_i = r_isco
    chi_i = chi_BH
    inc_i = inc_BH

    nu  = symmetric_mass_ratio(M_BH, M_NS)
    f_nu = transition_function(nu)
    M_disk = M_b*disk_mass_fit_ff(Q, C_NS, r_i*M_BH, R_NS)

    c_1 = chi_i*M_BH**2
    c_2 = M_BH*( M_NS*(1-f_nu) + f_nu*M_b - M_disk )
    c_3 = (M_BH+M_NS)*( 1 - (1-orbital_energy(r_i, chi_i, inc_i))*nu )
    c_4 = -M_disk

    # maybe I should multiply this by Q(r, chi)
    return (
            ( c_2*orbital_momentum(ISSO_R(chi_f, inc_f), chi_f, inc_f)*np.cos(np.radians(inc_f))
            + c_1*np.cos(np.radians(inc_i) - np.radians(inc_f))
            - chi_f*(c_3 + c_4*orbital_energy(ISSO_R(chi_f, inc_f), chi_f, inc_f))**2
            )
            ,
            ( c_2*orbital_momentum(ISSO_R(chi_f, inc_f), chi_f, inc_f)*np.sin(np.radians(inc_f))
            - c_1*np.sin(np.radians(inc_i) - np.radians(inc_f))
            )
           )

def spin_solver(r_i, chi_i, inc_i):
    chi_f, inc_f = fsolve(spin_equations, (chi_i, inc_i))
    m_bh_f = bh_mass_final(r_i, chi_i, inc_i, ISSO_R(chi_f, inc_f), chi_f, inc_f)
    return chi_f, m_bh_f, inc_f

def main(): 
    # Load the .dat file containing parameters from TOV solver
    configs=np.loadtxt('tov-quantities.dat', delimiter="\t",usecols=[1,2,3,4,5])
    names=np.genfromtxt('tov-quantities.dat',delimiter="\t",usecols=[0],dtype=np.str)

    f = open(str("output.dat"),"w")

    # Acquired from MakeTOVSequence.cpp
    print("# [1] System Name (e.g. DD2-M12)", file=f)
    print("# [2] rho_c [M_sun^{-2}]", file=f)
    print("# [3] M_{NS} (ADM) [M_sun]", file=f)
    print("# [4] R_{NS} [M_sun]", file=f)
    print("# [5] M^b_{NS} [M_sun]", file=f)
    print("# [6] k_2 (Love number)", file=f)
    # The computed values below will be appended
    print("# [7] r_isco [M_sun]", file=f)
    print("# [8] Lambda", file=f)
    print("# [9] M_ej (SACRA) [M_sun]", file=f)
    print("# [10] <v_ej> (SACRA) [c]", file=f)
    print("# [11] <v_ej_rms> (SpEC) [c]", file=f)
    print("# [12] <v_ej> (SpEC) [c]", file=f)
    print("# [13] M_disk (SpEC) [M_sun]", file=f)
    print("# [14] chi_BH_final (Pannarale)", file=f)
    print("# [15] M_BH_final (Pannarale) [M_sun]", file=f)
    print("# [16] inc_BH_final (Pannarale) [degrees]", file=f)
    print("# [17] r_isco^f [M_sun]", file=f)

    for i in range(len(configs)):
        # Params from .dat file
        rho_c = configs[i][0]
        M_NS = configs[i][1]
        R_NS = configs[i][2]
        M_b = configs[i][3]
        k_2 = configs[i][4]

        # Computed quantities
        E_b = binding_energy(M_NS, M_b)     # specific binding energy
        C_NS = M_NS/R_NS                    # NS compactness
        Q = M_BH/M_NS                       # mass ratio
        Lambda=tidal_parameter(k_2, C_NS)   # tidal parameter
        #r_isco = ISCO_R(chi_BH)            # ISCO radius, multiply by M_{BH} for units in
        #                                        # M_sun
        r_isco = ISSO_R(chi_BH, inc_BH)
        R_isco = r_isco*M_BH

        # to feed into the prediction solvers
        ID=M_NS,R_NS,C_NS,M_b,Q,M_BH

        # Predictions of ejecta and disk quantities
        # arxiv:1601.07711 
        m_ej_kk = M_b*ejecta_mass_fit_kk_v3(Q, C_NS, r_isco, E_b)   # untis of M_sun
        v_ej_kk = 0.01533*Q + 0.1907                                # units of c
        # arxiv:1611.01159
        v_ej_rms_ff = 0.0166*Q + 0.1657                             # units of c
        v_ej_ff = 0.0149*Q + 0.1493                                 # units of c
        # arxiv:1207.6304
        m_disk_ff = M_b*disk_mass_fit_ff(Q, C_NS, R_isco, R_NS)     # units of M_sun
        # Predictions of black hole quantities
        # arxiv:1311.5931v2
        chi_bh_fp, m_bh_fp, inc_bh_fp = spin_final(ID, r_isco, chi_BH, inc_BH)
        #chi_bh_f, m_bh_fp, inc_bh_fp = spin_solver(r_isco, chi_BH, inc_BH) 

        r_isco_fp = ISSO_R(chi_bh_fp, inc_bh_fp)

        print(
        names[i]
        ,rho_c
        ,M_NS
        ,R_NS
        ,M_b
        ,k_2
        ,r_isco*M_BH
        ,Lambda
        ,m_ej_kk
        ,v_ej_kk
        ,v_ej_rms_ff
        ,v_ej_ff
        ,m_disk_ff
        ,chi_bh_fp
        ,m_bh_fp
        ,inc_bh_fp
        ,r_isco_fp*m_bh_fp
        ,file=f)
main()
