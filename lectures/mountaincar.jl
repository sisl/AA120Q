using Cairo, Colors, Printf

mutable struct MountainCar
    x::Float64 # position
    v::Float64 # speed
end

function update(car::MountainCar, a::Symbol)
    if a == :left
        act = -1
    elseif a == :right
        act = 1
    elseif a == :coast
        act = 0
    else
        error("Invalid action: $a")
    end
    v2 = car.v + act * 0.001 + cos(3 * car.x) * (-0.0025)
    v2 = clamp(v2, -0.07, 0.07)
    x2 = clamp(car.x + v2, -1.2, 0.6)
    return MountainCar(x2, v2)
end

function Cairo.set_source_rgba(ctx::CairoContext, color::Colorant)
    r = convert(Float64, red(color))
    g = convert(Float64, green(color))
    b = convert(Float64, blue(color))
    a = convert(Float64, alpha(color))
    set_source_rgba(ctx, r, g, b, a)
    ctx
end

get_terrain_height(x) = 1/3*sin(3 * x) + 1/3

reward(car::MountainCar, a::Symbol) = get_terrain_height(car.x)

function render_terrain!(ctx::CairoContext, color::Colorant=colorant"grey")
    Cairo.save(ctx)
    set_source_rgba(ctx, color)
    
    new_sub_path(ctx)
    move_to(ctx, -1.2, -0.01)
    line_to(ctx, 0.6, -0.01)
    for x in range(0.6, stop=-1.2, length=101)
        line_to(ctx, x, get_terrain_height(x))
    end
    close_path(ctx)

    Cairo.fill(ctx)
    
    restore(ctx)
    ctx
end

function render_mountain_car!(ctx::CairoContext, car::MountainCar, color::Colorant=colorant"black"; car_radius::Float64=0.05)
    Cairo.save(ctx)
    
    Cairo.translate(ctx, car.x, get_terrain_height(car.x) + car_radius)

    Cairo.arc(ctx, 0.0, 0.0, car_radius, 0, 2pi)
    set_source_rgba(ctx, color)
    Cairo.fill(ctx)
    
    restore(ctx)
    ctx
end

function render_position_overlay!(ctx::CairoContext, car::MountainCar, color::Colorant=colorant"black"; car_radius::Float64=0.05)

    Cairo.save(ctx)

    # draw horizontal position line
    set_source_rgba(ctx, color)
    set_line_width(ctx, 2.0) # [pixels]

    y = get_terrain_height(car.x) + car_radius
    move_to(ctx, car.x, y)
    # line_to(ctx, 0.0, y)

    move_to(ctx, 0.0, y-0.04)
    # line_to(ctx, 0.0, y+0.04)
    # Cairo.stroke(ctx)
    restore(ctx)


    # deal with the inverted y-axis issue for text rendered
    mat = get_matrix(ctx)
    mat2 = [mat.xx mat.xy mat.x0;
            mat.yx mat.yy mat.y0]

    Cairo.save(ctx)
    reset_transform(ctx)
    select_font_face(ctx, "Sans", Cairo.FONT_SLANT_NORMAL, Cairo.FONT_WEIGHT_NORMAL)
    set_font_size(ctx, 35)
    set_source_rgba(ctx, color)

    # position line label (handle center alignment)
    text_x = car.x
    text_y = y + 0.13
    pos = mat2*[text_x text_y 1.0]'
    text = @sprintf("x = %7.2f", car.x)
    extents = Cairo.text_extents(ctx, text)
    pos[1] -= (extents[3]/2 + extents[1])
    pos[2] -= (extents[4]/2 + extents[2])
    move_to(ctx, pos[1], pos[2])
    show_text(ctx, text)

    # speed label
    text_x = car.x
    text_y = y + 0.08
    pos = mat2*[text_x text_y 1.0]'
    text = @sprintf("v = %+7.2f", car.v)
    extents = Cairo.text_extents(ctx, text)
    pos[1] -= (extents[3]/2 + extents[1])
    pos[2] -= (extents[4]/2 + extents[2])
    move_to(ctx, pos[1], pos[2])
    show_text(ctx, text)

    restore(ctx)

    ctx
end

function render_action_overlay!(ctx::CairoContext, car::MountainCar, action::Symbol, color::Colorant=colorant"maroon", car_radius::Float64=0.05)
    # Draw an arrow pointing to the direction of the action
    
    # Determine arrow direction based on action
    if action == :left
        angle = pi
    elseif action == :right
        angle = 0
    else
        return ctx
    end
    
    Cairo.save(ctx)
    set_source_rgba(ctx, color)
    Cairo.translate(ctx, car.x, get_terrain_height(car.x) + car_radius)
    
    # Draw arrow
    arrow_length = 0.12
    arrow_width = 0.04
    move_to(ctx, 0, 0)
    set_line_width(ctx, 8.0)
    line_to(ctx, arrow_length * cos(angle)*0.98, arrow_length * sin(angle)*0.98)
    Cairo.stroke(ctx)
    move_to(ctx, arrow_length * cos(angle), arrow_length * sin(angle))
    line_to(ctx, (arrow_length - arrow_width) * cos(angle - pi/12), (arrow_length - arrow_width) * sin(angle - pi/12))
    line_to(ctx, (arrow_length - arrow_width) * cos(angle + pi/12), (arrow_length - arrow_width) * sin(angle + pi/12))
    close_path(ctx)
    Cairo.fill(ctx)
    
    restore(ctx)
    ctx
end

function render_reward!(ctx::CairoContext, reward::Float64, color::Colorant=colorant"black")
    # deal with the inverted y-axis issue for text rendered
    mat = get_matrix(ctx)
    mat2 = [mat.xx mat.xy mat.x0;
            mat.yx mat.yy mat.y0]

    Cairo.save(ctx)
    reset_transform(ctx)
    select_font_face(ctx, "Sans", Cairo.FONT_SLANT_NORMAL, Cairo.FONT_WEIGHT_NORMAL)
    set_font_size(ctx, 45)
    set_source_rgba(ctx, color)

    # position line label (handle center alignment)
    text_x = -0.3
    text_y = 0.5
    pos = mat2*[text_x text_y 1.0]'
    text = @sprintf("R = %7.3f", reward)
    extents = Cairo.text_extents(ctx, text)
    pos[1] -= (extents[3]/2 + extents[1])
    pos[2] -= (extents[4]/2 + extents[2])
    move_to(ctx, pos[1], pos[2])
    show_text(ctx, text)

    restore(ctx)
    ctx
end

function render_mountain_car(car::MountainCar, color::Colorant=colorant"blue";
    canvas_width::Int = 1440,
    canvas_height::Int = 800,
    camera_pos::Tuple{Float64,Float64} = (-0.3,0.5),
    camera_zoom::Float64 = 800.0,
    render_pos_overlay::Bool = false,
    reward::Float64=NaN,
    action::Symbol=:none
    )

    s, ctx = get_canvas_and_context(canvas_width, canvas_height, camera_zoom=camera_zoom, camera_pos=camera_pos)
    render_terrain!(ctx)
    render_mountain_car!(ctx, car, color)
    
    if render_pos_overlay
        render_position_overlay!(ctx, car)
    end
    
    if !isnan(reward)
        render_reward!(ctx, reward)
    end
    
    if action != :none
        render_action_overlay!(ctx, car, action)
    end
    
    s
end

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
