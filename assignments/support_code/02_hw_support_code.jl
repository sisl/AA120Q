struct HW2_Support_Code end

struct AircraftState
	x::Float64  # horizontal position [m]
	y::Float64  # veritcal position   [m]
	u::Float64  # horizontal speed    [m/s]
	v::Float64  # vertical speed      [m/s]
end

mutable struct EncounterState
	plane1::AircraftState
	plane2::AircraftState
	t::Float64
end

struct DiscretizedBayesNet
    dbn::DiscreteBayesNet
    discs::Dict{Symbol, LinearDiscretizer}
end

function Base.show(io::IO, aircraft_state::AircraftState)
    println(io, "Aircraft State:")
    println(io, "\tx (m): $(aircraft_state.x)")
    println(io, "\ty (m): $(aircraft_state.y)")
    println(io, "\tu (m/s): $(aircraft_state.u)")
    println(io, "\tv (m/s): $(aircraft_state.v)")
end

function Base.show(io::IO, encounter_state::EncounterState)
    println(io, "Encounter State")
    
    println(io, "\tt (s): $(encounter_state.t)")
    
    println(io, "\tPlane 1")
    println(io, "\t\tx (m): $(encounter_state.plane1.x)")
    println(io, "\t\ty (m): $(encounter_state.plane1.y)")
    println(io, "\t\tu (m/s): $(encounter_state.plane1.u)")
    println(io, "\t\tv (m/s): $(encounter_state.plane1.v)")
    
    println(io, "\tPlane 2")
    println(io, "\t\tx (m): $(encounter_state.plane2.x)")
    println(io, "\t\ty (m): $(encounter_state.plane2.y)")
    println(io, "\t\tu (m/s): $(encounter_state.plane2.u)")
    println(io, "\t\tv (m/s): $(encounter_state.plane2.v)")
end

const Encounter = Vector{EncounterState}

flights = CSV.read(joinpath(@__DIR__, "../..", "data", "flights.csv"), DataFrame)

function pull_encounter(flights::DataFrame, id::Int)
	enc = Encounter()
	data = flights[flights.id .== id, :]
	for i = 1:51
		x1, y1, u1, v1 = data[i, :x1], data[i, :y1], data[i, :u1], data[i, :v1]
		x2, y2, u2, v2 = data[i, :x2], data[i, :y2], data[i, :u2], data[i, :v2]

		plane1 = AircraftState(x1, y1, u1, v1)
		plane2 = AircraftState(x2, y2, u2, v2)

		push!(enc, EncounterState(plane1, plane2, i - 1))
	end

	return enc # returns the vector of EncounterStates
end

encounter_set = [pull_encounter(flights, id) for id = 1:1000]

# Finds the overall separation between two aircraft
get_separation(state::EncounterState) = hypot(state.plane1.x - state.plane2.x,
											  state.plane1.y - state.plane2.y)

# Determines what is the minimum separation between the two aircraft
get_min_separation(enc::Encounter) = minimum(get_separation(s) for s in enc)

find_min_separation(enc::Encounter) = argmin([get_separation(s) for s in enc])

function plot_encounter(enc::Encounter) 
	d = get_min_separation(enc)  # closest dist 
	i = find_min_separation(enc) # index of closest dist

	palette=[colorant"0x52E3F6", colorant"0x79ABFF", colorant"0xFF007F"]
	t_arr = collect(1:length(enc)) .- 1 # time interval

	# Gets the x and y values for both planes 
	x1_arr = map(s->s.plane1.x, enc)
	y1_arr = map(s->s.plane1.y, enc)
	x2_arr = map(s->s.plane2.x, enc)
	y2_arr = map(s->s.plane2.y, enc)

	# Plots the trajectories 
	p1 = plot(Vector{Float64}[x1_arr, x2_arr, [enc[i].plane1.x, enc[i].plane2.x]],
			  Vector{Float64}[y1_arr, y2_arr, [enc[i].plane1.y, enc[i].plane2.y]],
			  xlabel="x [m]", ylabel="y [m]",
			  label=["Plane1" "Plane2" "Min Separation"],
			  palette=palette, linewidth=4)

	# Plots the point where the minimum separation occurs 
	scatter!(p1, Vector{Float64}[Float64[enc[1].plane1.x],
			 Float64[enc[1].plane2.x]],
			 Vector{Float64}[Float64[enc[1].plane1.y], Float64[enc[1].plane2.y]],
			 label=["Plane1 Initial" "Plane2 Initial"])

    plot(p1, size=(690,400), legend=:outertopright)
end
