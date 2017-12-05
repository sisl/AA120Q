const AIRPLANE_IMAGE = read_from_png(Pkg.dir("AA120Q", "data", "airplane-top-view.png"))
const AIRPLANE_LENGTH = 70.7136 # meters
const AIRPLANE_SCALE = AIRPLANE_LENGTH/AIRPLANE_IMAGE.width

function get_canvas_and_context(canvas_width::Int, canvas_height::Int;
    camera_pos::Tuple{Float64,Float64} = (0.0,0.0), # [m]
    camera_zoom::Float64 = 0.5, # [pix/m]
    )
    s = CairoRGBSurface(canvas_width, canvas_height)
    ctx = creategc(s)

    # clear background
    set_source_rgb(ctx, 1.0,1.0,1.0)
    paint(ctx)

    # reset the transform such that (0,0) is the middle of the image
    reset_transform(ctx)
    Cairo.translate(ctx, canvas_width/2, canvas_height/2)                 # translate to image center
    Cairo.scale(ctx, camera_zoom, -camera_zoom )  # [pix -> m]
    Cairo.translate(ctx, -camera_pos[1], -camera_pos[2]) # translate to camera location

    (s, ctx)
end

function center_on_aircraft!(ctx::CairoContext, states::AircraftState...)
    x = 0.0
    y = 0.0
    for s in states
        x += s.x
        y += s.y
    end
    Cairo.translate(ctx, -x/length(states), -y/length(states))
    ctx
end

function render!(ctx::CairoContext, s::AircraftState)
    Cairo.save(ctx)
    Cairo.translate(ctx, s.x, s.y)
    #Cairo.rotate(ctx, π/2+deg2rad(s.ψ))
    Cairo.translate(ctx,-AIRPLANE_LENGTH/2, -AIRPLANE_LENGTH/2)
    Cairo.scale(ctx, AIRPLANE_SCALE, AIRPLANE_SCALE)
    set_source_surface(ctx, AIRPLANE_IMAGE, 0.0, 0.0)
    paint(ctx)
    restore(ctx)
end

function render(s1::AircraftState, s2::AircraftState;
    canvas_width::Int = 1000,
    canvas_height::Int = 600,
    )

    s, ctx = get_canvas_and_context(canvas_width, canvas_height)
    render!(ctx, s1)
    render!(ctx, s2)
    s
end

function render!(ctx::CairoContext, trace::Vector{AircraftState}, color::Tuple{Float64,Float64,Float64,Float64})
    Cairo.save(ctx)
    set_source_rgba(ctx,0.0,0.0,1.0,1.0)
    set_line_width(ctx,0.5)

    move_to(ctx, trace[1].x, trace[1].y)
    for i in 2 : length(trace)
        line_to(ctx, trace[i].x, trace[i].y)
    end
    Cairo.stroke(ctx)
    restore(ctx)
end

function render(traj::Trajectory, t::Float64;
    canvas_width::Int = 1000,
    canvas_height::Int = 600,
    zoom::Float64 = 0.1,
    )

    s, ctx = get_canvas_and_context(canvas_width, canvas_height, camera_zoom=zoom)

    # pull the current aircraft positions
    plane1 = [s.plane1 for s in traj]
    plane2 = [s.plane2 for s in traj]
    
    s1 = get_interpolated_state(plane1, 1.0, t)
    s2 = get_interpolated_state(plane2, 1.0, t)

    # center
    center_on_aircraft!(ctx, s1, s2)

    # render the aircraft traces
    render!(ctx, plane1, (0.0,0.0,1.0,1.0))
    render!(ctx, plane2, (0.0,0.0,1.0,1.0))

    # render the current aircraft positions
    render!(ctx, s1)
    render!(ctx, s2)

    s
end