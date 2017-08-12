
mutable struct EncounterState
    plane1::AircraftState
    plane2::AircraftState
    t::Float64 # constant timestep between frames [sec]
end

const Trajectory = Vector{EncounterState}

struct Encounter
    traj::Trajectory
    advisories::Vector{Advisory}
end

get_separation(state::EncounterState) = hypot(state.plane1.x - state.plane2.x,
                                              state.plane1.y - state.plane2.y)
get_separation_x(state::EncounterState) = abs(state.plane1.x - state.plane2.x)
get_separation_y(state::EncounterState) = abs(state.plane1.y - state.plane2.y)

get_min_separation(traj::Trajectory) = minimum(get_separation(s) for s in traj)
find_min_separation(traj::Trajectory) = indmin(get_separation(s) for s in traj)

get_min_x_separation(traj::Trajectory) = minimum(get_separation_x(s) for s in traj)
find_min_x_separation(traj::Trajectory) = indmin(get_separation_x(s) for s in traj)

get_min_y_separation(traj::Trajectory) = minimum(get_separation_y(s) for s in traj)
find_min_y_separation(traj::Trajectory) = indmin(get_separation_y(s) for s in traj)

const NMAC_THRESOLD_VERT = 30.0 # [m]
const NMAC_THRESOLD_HORZ = 150.0 # [m]
function is_nmac(s1::AircraftState, s2::AircraftState)
    Δvert = abs(s1.y - s2.y)
    Δhorz = abs(s1.x - s2.x)
    Δvert ≤ NMAC_THRESOLD_VERT && Δhorz ≤ NMAC_THRESOLD_HORZ
end
function has_nmac(traj::Trajectory)
    for i in 1 : length(traj)
        if is_nmac(traj[i].plane1, traj[i].plane2)
            return true
        end
    end
    false
end

function plot_separations(traj::Trajectory)
<<<<<<< HEAD
    palette=[colorant"0x52E3F6", colorant"0x79ABFF", colorant"0xFF007F"]
    t_arr = (collect(1:length(traj)).-1)
    
    sep_arr = get_separation.(traj)        # get total separation
    sep_x_arr = get_separation_x.(traj)    # get horizontal separation
    sep_y_arr = get_separation_y.(traj)    # get vertical separation 
    
    p1 = plot(Vector{Float64}[t_arr, t_arr, t_arr], 
              Vector{Float64}[sep_arr, sep_x_arr, sep_y_arr],
              xlabel="Time(s)", palette=palette, linewidth=4)
    
    plot(p1, size=(800,400))
end

# plot using the vector of trajectories
function plot_trajectory(traj::Trajectory, index::Int)
    
    d = get_min_separation(traj)  # closest dist 
    i = find_min_separation(traj) # index of closest dist

    palette=[colorant"0x52E3F6", colorant"0x79ABFF", colorant"0xFF007F"]
    t_arr = (collect(1:length(traj)).-1) #.* traj.Δt

    x1_arr = map(s->s.plane1.x,traj)
    y1_arr = map(s->s.plane1.y,traj)
    x2_arr = map(s->s.plane2.x,traj)
    y2_arr = map(s->s.plane2.y,traj)

    p1 = plot(Vector{Float64}[x1_arr, x2_arr, [traj[i].plane1.x, traj[i].plane2.x]],
              Vector{Float64}[y1_arr, y2_arr, [traj[i].plane1.y, traj[i].plane2.y]],
              xlabel="x [m]", ylabel="y [m]", label=["Plane1" "Plane2" "Min Separation"],
              palette=palette, linewidth=4)
    
    scatter!(p1, Vector{Float64}[Float64[traj[1].plane1.x], Float64[traj[1].plane2.x]],
                 Vector{Float64}[Float64[traj[1].plane1.y], Float64[traj[1].plane2.y]],
                 label=["Plane1 Initial" "Plane2 Initial"])
    
    plot(p1, size=(800,400))
end    
    
function plot_trajectory(enc::Encounter)
    
    traj = enc.traj
    
    d = get_min_separation(traj)  # closest dist 
    i = find_min_separation(traj) # index of closest dist

    palette=[colorant"0x52E3F6", colorant"0x79ABFF", colorant"0xFF007F"]
    t_arr = (collect(1:length(traj)).-1) #.* traj.Δt

    x1_arr = map(s->s.plane1.x,traj)
    y1_arr = map(s->s.plane1.y,traj)
    x2_arr = map(s->s.plane2.x,traj)
    y2_arr = map(s->s.plane2.y,traj)

    p1 = plot(Vector{Float64}[x1_arr, x2_arr, [traj[i].plane1.x, traj[i].plane2.x]],
              Vector{Float64}[y1_arr, y2_arr, [traj[i].plane1.y, traj[i].plane2.y]],
              xlabel="x [m]", ylabel="y [m]", label=["Plane1" "Plane2" "Min Separation"],
              palette=palette, linewidth=4)
    
    scatter!(p1, Vector{Float64}[Float64[traj[1].plane1.x], Float64[traj[1].plane2.x]],
                 Vector{Float64}[Float64[traj[1].plane1.y], Float64[traj[1].plane2.y]],
                 label=["Plane1 Initial" "Plane2 Initial"])

    # indicate when advisories were issued
    advisory_x_vals = Float64[]
=======
    palette=[colorant"0x52E3F6", colorant"0x79ABFF", colorant"0xFF007F"]
    t_arr = (collect(1:length(traj)).-1)
    
    sep_arr = get_separation.(traj)        # get total separation
    sep_x_arr = get_separation_x.(traj)    # get horizontal separation
    sep_y_arr = get_separation_y.(traj)    # get vertical separation 
    
    p1 = plot(Vector{Float64}[t_arr, t_arr, t_arr], 
              Vector{Float64}[sep_arr, sep_x_arr, sep_y_arr],
              xlabel="Time(s)", palette=palette, linewidth=4)
    
    plot(p1, size=(950,400))
end

# plot using the vector of trajectories
function plot_encounter(traj::Trajectory, index::Int)
    
    d = get_min_separation(traj)  # closest dist 
    i = find_min_separation(traj) # index of closest dist

    palette=[colorant"0x52E3F6", colorant"0x79ABFF", colorant"0xFF007F"]
    t_arr = (collect(1:length(traj)).-1) #.* traj.Δt

    x1_arr = map(s->s.plane1.x,traj)
    y1_arr = map(s->s.plane1.y,traj)
    x2_arr = map(s->s.plane2.x,traj)
    y2_arr = map(s->s.plane2.y,traj)

    min_x1, max_x1 = extrema(x1_arr)
    min_y1, max_y1 = extrema(y1_arr)
    min_x2, max_x2 = extrema(x2_arr)
    min_y2, max_y2 = extrema(y2_arr)

    max_x = max(max_x1, max_x2)
    max_y = max(max_y1, max_y2)
    min_x = min(min_x1, min_x2)
    min_y = min(min_y1, min_y2)

    w = max(abs(max_x), abs(min_x), abs(max_y), abs(min_y)) + 150

     p1 = plot(Vector{Float64}[x1_arr, x2_arr, [traj[i].plane1.x, traj[i].plane2.x]],
               Vector{Float64}[y1_arr, y2_arr, [traj[i].plane1.y, traj[i].plane2.y]],
              xlabel="Horizontal Distance (m)", ylabel="Vertical Distance (m)", palette=palette, linewidth=4, xlims=(-w,w), ylims=(-w,w))
    scatter!(p1, Vector{Float64}[Float64[traj[1].plane1.x], Float64[traj[1].plane2.x]],
                 Vector{Float64}[Float64[traj[1].plane1.y], Float64[traj[1].plane2.y]])
    
    plot(p1, size=(950,400))
end    
    
function plot_encounter(enc::Encounter)
    
    traj = enc.traj

    d = get_min_separation(traj)  # closest dist 
    i = find_min_separation(traj) # index of closest dist
    
    palette=[colorant"0x52E3F6", colorant"0x79ABFF", colorant"0xFF007F"]
    t_arr = (collect(1:length(traj1)).-1) #.* enc.Δt

    x1_arr = map(s->s.plane1.x,traj)
    y1_arr = map(s->s.plane1.y,traj)
    x2_arr = map(s->s.plane2.x,traj)
    y2_arr = map(s->s.plane2.y,traj)

    min_x1, max_x1 = extrema(x1_arr)
    min_y1, max_y1 = extrema(y1_arr)
    min_x2, max_x2 = extrema(x2_arr)
    min_y2, max_y2 = extrema(y2_arr)

    max_x = max(max_x1, max_x2)
    max_y = max(max_y1, max_y2)
    min_x = min(min_x1, min_x2)
    min_y = min(min_y1, min_y2)

    w = max(abs(max_x), abs(min_x), abs(max_y), abs(min_y)) + 150

    p1 = plot(Vector{Float64}[x1_arr, x2_arr, [traj1[i].x, traj2[i].x]],
              Vector{Float64}[y1_arr, y2_arr, [traj1[i].y, traj2[i].y]],
              xlabel="Horizontal Distance (m)", ylabel="Vertical Distance (m)", palette=palette, linewidth=4, xlims=(-w,w), ylims=(-w,w))
    scatter!(p1, Vector{Float64}[Float64[traj1[1].x], Float64[traj2[1].x]],
                 Vector{Float64}[Float64[traj1[1].y], Float64[traj2[1].y]])

    # indicate when advisories were issued
    advisory_t_vals = Float64[]
>>>>>>> 34d9dd80b5f647280fd6b47c3d97bbbfabf02265
    advisory_y_vals = Float64[]

    prev_climb_rate = NaN

    let
        t = 0.0
        for (i,advisory) in enumerate(enc.advisories)
            if !is_no_advisory(advisory) && !isapprox(advisory.climb_rate, prev_climb_rate)
                prev_climb_rate = advisory.climb_rate
<<<<<<< HEAD
                push!(advisory_x_vals, traj[i].plane1.x)
=======
                push!(advisory_t_vals, t)
>>>>>>> 34d9dd80b5f647280fd6b47c3d97bbbfabf02265
                push!(advisory_y_vals, traj[i].plane1.y)
            end
            t += 1.0
        end
    end

<<<<<<< HEAD
    scatter!(p1, advisory_x_vals, advisory_y_vals, label="Advisory")
    
    plot(p1, size=(800,400))
=======
    scatter!(p2, advisory_t_vals, advisory_h_vals)

    plot(p1, p2, size=(950,400))
>>>>>>> 34d9dd80b5f647280fd6b47c3d97bbbfabf02265
end

function pull_trajectory(flights::DataFrame, id::Int)
    flightids = flights[:id]
    i = findfirst(flightids, id)
    j = findlast(flightids, id)
    traj = Vector{EncounterState}(j-i+1)
    
    for (idx,frame) in enumerate(i : j)
        
        t = idx - 1.0 # set initial time to zero
        
        plane1 = AircraftState(flights[frame, :x1], flights[frame, :y1], flights[frame, :u1], flights[frame, :v1])
        
        plane2 = AircraftState(flights[frame, :x2], flights[frame, :y2], flights[frame, :u2], flights[frame, :v2])
        
        traj[idx] = EncounterState(plane1, plane2, t)
    end
    return traj
end

function pull_trajectories(flights::DataFrame, N::Int=nrow(initial))
    N = clamp(N, 0, nrow(flights))
    return [pull_trajectory(flights, id) for id in 1:N]
end