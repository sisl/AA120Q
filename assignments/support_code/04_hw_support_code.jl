struct HW4_Support_Code end

function is_alert(advisories::Vector{Symbol})
	return any(advisories .!= :COC)
end

function num_alerts(advisories::Vector{Symbol})
	return sum(advisories .!= :COC)
end

function plot_encounter(enc::Encounter, advisories::Vector{Symbol}) 
	p1 = plot_encounter(enc)
	
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

	p1 = plot!(p1, size=(690,400), legend=:outertopright)
end

function simulate_encounter(enc::Encounter, cas_function::Function)
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
