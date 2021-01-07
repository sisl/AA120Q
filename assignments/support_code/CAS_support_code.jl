## NOTE:THIS FILE CONTAINS SOLUTIONS TO PREVIOUS EXERCISES.
## Please do not look at this file until you have turned in assignment
## 3. Doing so before turning in assignment 3 will be considered a
## violation of the honor code. Thanks!!

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

const Encounter = Vector{EncounterState}

flights = CSV.read(joinpath(@__DIR__, "../..", "data", "flights.csv"), DataFrame)

function pull_encounter(flights::DataFrame, id::Int)

	flightids = flights[:id] # Gets the data from the specific ID we pass in	
	enc = Encounter()

	# STUDENT CODE START
	data = flights[flights.id .== id, :]

	for i = 1:51
		x1, y1, u1, v1 = data[i, :x1], data[i, :y1], data[i, :u1], data[i, :v1]
		x2, y2, u2, v2 = data[i, :x2], data[i, :y2], data[i, :u2], data[i, :v2]

		plane1 = AircraftState(x1, y1, u1, v1)
		plane2 = AircraftState(x2, y2, u2, v2)

		push!(enc, EncounterState(plane1, plane2, i - 1))
	end
	# STUDENT CODE END

	return enc # returns the vector of EncounterStates
end

encounter_set = [pull_encounter(flights, id) for id = 1:1000]

function simulate_encounter(enc::Encounter, cas_function)
	alerted = false

	advisories = Vector{Symbol}()
	sim_enc = Encounter()
	push!(sim_enc, enc[1])

	for i = 2:length(enc)
		curr = sim_enc[end]
		advisory = cas_function(curr)
		push!(advisories, advisory)

		if advisory == :COC
			if !alerted
				push!(sim_enc, enc[i])
			else
				x1, y1, u1, v1 = curr.plane1.x, curr.plane1.y, curr.plane1.u, curr.plane1.v
				x2, y2, u2, v2 = curr.plane2.x, curr.plane2.y, curr.plane2.u, curr.plane2.v
				p1 = AircraftState(enc[i].plane1.x, y1, enc[i].plane1.u, 0.0)
				p2 = enc[i].plane2
				push!(sim_enc, EncounterState(p1, p2, i - 1.0))
			end
		elseif advisory == :CLIMB
			alerted = true
			x1, y1, u1, v1 = curr.plane1.x, curr.plane1.y, curr.plane1.u, curr.plane1.v
			x2, y2, u2, v2 = curr.plane2.x, curr.plane2.y, curr.plane2.u, curr.plane2.v
			p1 = AircraftState(enc[i].plane1.x, y1 + 1500 * 0.00508, enc[i].plane1.u, 1500 * 0.00508)
			p2 = enc[i].plane2
			push!(sim_enc, EncounterState(p1, p2, i - 1.0))
		elseif advisory == :DESCEND
			alerted = true
			x1, y1, u1, v1 = curr.plane1.x, curr.plane1.y, curr.plane1.u, curr.plane1.v
			x2, y2, u2, v2 = curr.plane2.x, curr.plane2.y, curr.plane2.u, curr.plane2.v
			p1 = AircraftState(enc[i].plane1.x, y1 - 1500 * 0.00508, enc[i].plane1.u, -1500 * 0.00508)
			p2 = enc[i].plane2
			push!(sim_enc, EncounterState(p1, p2, i - 1.0))
		else
			error("Invalid Advisory")
		end
	end

	return sim_enc, advisories
end

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

	plot(p1, size=(600,400))
end

function plot_encounter(enc::Encounter, advisories::Vector{Symbol}) 
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
	
	descend_inds = findall(advisories .== :DESCEND) .+ 1
	climb_inds = findall(advisories .== :CLIMB) .+ 1
	
	if length(descend_inds) > 0
		x_descend = [enc[ind].plane1.x for ind in descend_inds]
		y_descend = [enc[ind].plane1.y for ind in descend_inds]
		scatter!(p1, x_descend, y_descend, label = "DESCEND", color = "green")
	end
	
	if length(climb_inds) > 0
		x_climb = [enc[ind].plane1.x for ind in climb_inds]
		y_climb = [enc[ind].plane1.y for ind in climb_inds]
		scatter!(p1, x_climb, y_climb, label = "CLIMB", color = "red")
	end

	plot(p1, size=(600,400))
end

function is_nmac_state(enc_state::EncounterState)
	nmac = false

	# STUDENT CODE START
	x1 = enc_state.plane1.x
	y1 = enc_state.plane1.y
	x2 = enc_state.plane2.x
	y2 = enc_state.plane2.y

	nmac = abs(x1 - x2) < 500 * 0.3048 && abs(y1 - y2) < 100 * 0.3048
	# STUDENT CODE END

	return nmac
end

function is_nmac(enc::Encounter)
	is_nmac = false

	# STUDENT CODE START
	for i = 1:length(enc)
		if is_nmac_state(enc[i])
			is_nmac = true
			break
		end
	end
	# STUDENT CODE END

	return is_nmac
end

function is_alert(advisories::Vector{Symbol})
	return any(advisories .!= :COC)
end

function num_alerts(advisories::Vector{Symbol})
	return sum(advisories .!= :COC)
end