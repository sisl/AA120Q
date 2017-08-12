mutable struct TCAS <: FullyObservableCollisionAvoidanceSystem
    advisory::Advisory
    climb_rate::Float64
    TCAS(climb_rate::Float64=1500/60, advisory::Advisory=ADVISORY_NONE) = new(advisory, min(abs(climb_rate), CLIMB_RATE_MAX))
end

function reset!(tcas::TCAS)
    tcas.advisory = ADVISORY_NONE
    tcas
end
function update!(tcas::TCAS, s1::AircraftState, s2::AircraftState, params::EncounterSimParams)

    if is_no_advisory(tcas.advisory)
        # test for a threat

        # pull TCAS observations
        x1, y1, vx1, vy1, = s1.x, s1.y, s1.v, s1.u
        
        x2, y2, vx2, vy2, = s2.x, s2.y, s2.v, s2.u

        dxy = [(x2 - x1), (y2 - y1)]
        dvxy = [(vx2 - vx1), (vy2 - vy1)]

        r = norm(dxy) # range [m]
        r_dot = dot(dxy,dvxy) / norm(dxy) # range rate [m/s]

<<<<<<< HEAD
        # a = abs(y1 - y2) # relative altitude [m]
        # a_dot = sign(y2 - y1) * (y2_dot - y1_dot) # relative altitude rate of change [m/s]
=======
        # a = abs(h1 - h2) # relative altitude [ft]
        # a_dot = sign(h2 - h1) * (h2_dot - h1_dot) # relative altitude rate of change [ft/s]
>>>>>>> 34d9dd80b5f647280fd6b47c3d97bbbfabf02265

        # get range parameters based on our altitude
        if y1 < 1000
            sl = 2
            tau = 0
            dmod = 0
            zthr = 0
            alim = 0
        elseif y1 < 2350
            sl = 3
            tau = 15
            dmod = 0.2 * 6076.12
            zthr = 600
            alim = 300
        elseif y1 < 5000
            sl = 4
            tau = 20
            dmod = 0.35 * 6076.12
            zthr = 600
            alim = 300
        elseif y1 < 10000
            sl = 5
            tau = 25
            dmod = 0.55 * 6076.12
            zthr = 600
            alim = 350
        elseif y1 < 20000
            sl = 6
            tau = 30
            dmod = 0.80 * 6076.12
            zthr = 600
            alim = 400
        elseif y1 < 42000
            sl = 7
            tau = 35
            dmod = 1.10 * 6076.12
            zthr = 700
            alim = 600
        else
            sl = 7
            tau = 35
            dmod = 1.10 * 6076.12
            zthr = 800
            alim = 700
        end

        # test for activation
        if (r_dot < 0 && (-(r - dmod) / r_dot <= tau || r < dmod)) && ((a_dot < 0 && -a / a_dot <= tau) || a <= zthr)

            ascend_cross = false
            ascend_dist = 0
            ascend_alim = false

            descend_cross = false
            descend_dist = 0
            descend_alim = false

            t_ = -r / r_dot # time to closest approach

            ###################################################################
            # test ascend command

            y1_dot_ascend = tcas.climb_rate

            y1_cpa = y1 + y1_dot_ascend * t_ # altitude of AC1 at closest point of approach
            y2_cpa = y2 + y2_dot * t_       # altitude of AC2 at closest point of approach

            if (y1 <= y2 && y1_cpa >= y2_cpa) || (y1 >= y2 && y1_cpa <= y2_cpa)
                # we predict an ascend over the other aircraft or a descent under the other aircraft between now and CPA
                # if we issue an ascend
                ascend_cross = true
            end

            ascend_dist = abs(y1_cpa - y2_cpa) # altitude difference at CPA
            if ascend_dist >= alim
                # distance is greater than threshold (we are good)
                ascend_alim = true
            end

            ###################################################################
            # test descend command

            y1_dot_descend = -tcas.climb_rate

            y1_cpa = y1 + y1_dot_descend * t_ # altitude of AC1 at closest point of approach
            y2_cpa = y2 + y2_dot * t_         # altitude of AC2 at closest point of approach

            if (y1 <= y2 && y1_cpa >= y2_cpa) || (y1 >= y2 && y1_cpa <= y2_cpa)
                # we predict an ascend over the other aircraft or a descent under the other aircraft between now and CPA
                # if we issue a descend
                descend_cross = true
            end

            descend_dist = abs(y1_cpa - y2_cpa)
            if descend_dist >= alim
                # distance is greater than threshold (we are good)
                descend_alim = true
            end

            ###################################################################

            if ascend_cross
                if descend_alim
                    resolution_advisory = y1_dot_descend
                elseif ascend_alim
                    resolution_advisory = y1_dot_ascend
                else
                    resolution_advisory = y1_dot_descend
                end
            elseif descend_cross
                if ascend_alim
                    resolution_advisory = y1_dot_ascend
                elseif descend_alim
                    resolution_advisory = y1_dot_descend
                else
                    resolution_advisory = y1_dot_ascend
                end
            else
                if descend_alim && ascend_alim # best case scenario
                    if descend_dist < ascend_dist
                        resolution_advisory = y1_dot_descend
                    else
                        resolution_advisory = y1_dot_ascend
                    end
                elseif descend_alim
                    resolution_advisory = y1_dot_descend
                elseif ascend_alim
                    resolution_advisory = y1_dot_ascend
                else
                    if descend_dist > ascend_dist
                        resolution_advisory = y1_dot_descend
                    else
                        resolution_advisory = y1_dot_ascend
                    end
                end
            end

            tcas.advisory = Advisory(resolution_advisory)
        end
    end

    tcas.advisory
end
