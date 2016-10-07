using AA120Q, Reactive, Interact, Cairo, Colors

if !isdefined(:MountainCar)
    type MountainCar
        x::Float64 # position
        v::Float64 # speed
    end
end

reward(car::MountainCar, a::Symbol) = -cos(car.x/1.5*pi)

function AA120Q.update!(car::MountainCar, a::Symbol)
    act = (a == :left ? -1 : (a == :right ? 1 : 0))
    v2 = car.v + act*0.001 - sin((car.x/1.5 + 1)*pi)*-0.0025
    x2 = clamp(car.x + v2, -1.5, 1.5)
    MountainCar(x2, v2)
end

const CAR_RADIUS = 0.05

function Cairo.set_source_rgba(ctx::CairoContext, color::Colorant)
    r = convert(Float64, red(color))
    g = convert(Float64, green(color))
    b = convert(Float64, blue(color))
    a = convert(Float64, alpha(color))
    set_source_rgba(ctx, r, g, b, a)
    ctx
end
get_terrain_height(x) = 0.6*cos((x/1.5 + 1)*pi)
function render_terrain!(ctx::CairoContext, color::Colorant=colorant"black")
    Cairo.save(ctx)
    set_source_rgba(ctx, color)

    new_sub_path(ctx)
    move_to(ctx, -1.5,   -1.0)
    line_to(ctx,  1.5,   -1.0)
    for x in linspace(1.5,-1.5,101)
        line_to(ctx, x, get_terrain_height(x))
    end
    close_path(ctx)

    Cairo.fill(ctx)

    restore(ctx)
    ctx
end
function render_mountain_car!(ctx::CairoContext, car::MountainCar, color::Colorant=colorant"black")
    Cairo.save(ctx)

    Cairo.translate(ctx, car.x, get_terrain_height(car.x)+CAR_RADIUS)

    arc(ctx, 0.0, 0.0, CAR_RADIUS, 0, 2pi)
    set_source_rgba(ctx, color)
    Cairo.fill(ctx)

    restore(ctx)
    ctx
end
function render_position_overlay!(ctx::CairoContext, car::MountainCar, color::Colorant=colorant"black")

    Cairo.save(ctx)

    # draw horizontal position line
    set_source_rgba(ctx, color)
    set_line_width(ctx, 2.0) # [pixels]

    y = get_terrain_height(car.x)+CAR_RADIUS
    move_to(ctx, car.x, y)
    line_to(ctx, 0.0, y)

    move_to(ctx, 0.0, y-0.04)
    line_to(ctx, 0.0, y+0.04)
    Cairo.stroke(ctx)
    restore(ctx)


    # deal with the inverted y-axis issue for text rendered
    mat = get_matrix(ctx)
    mat2 = [mat.xx mat.xy mat.x0;
            mat.yx mat.yy mat.y0]

    Cairo.save(ctx)
    reset_transform(ctx)
    select_font_face(ctx, "Sans", Cairo.FONT_SLANT_NORMAL, Cairo.FONT_WEIGHT_NORMAL)
    set_font_size(ctx, 15)
    set_source_rgba(ctx, color)

    # position line label (handle center alignment)
    text_x = car.x/2
    text_y = y + 0.08
    pos = mat2*[text_x text_y 1.0]'
    text = @sprintf("x = %7.2f", car.x)
    extents = Cairo.text_extents(ctx, text)
    pos[1] -= (extents[3]/2 + extents[1])
    pos[2] -= (extents[4]/2 + extents[2])
    move_to(ctx, pos[1], pos[2])
    show_text(ctx, text)

    # speed label
    text_x = car.x
    text_y = y + 0.15
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
function render_reward!(ctx::CairoContext, reward::Float64, color::Colorant=colorant"black")
    # deal with the inverted y-axis issue for text rendered
    mat = get_matrix(ctx)
    mat2 = [mat.xx mat.xy mat.x0;
            mat.yx mat.yy mat.y0]

    Cairo.save(ctx)
    reset_transform(ctx)
    select_font_face(ctx, "Sans", Cairo.FONT_SLANT_NORMAL, Cairo.FONT_WEIGHT_NORMAL)
    set_font_size(ctx, 15)
    set_source_rgba(ctx, color)

    # position line label (handle center alignment)
    text_x = 0.0
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
function render_mountain_car(car::MountainCar, color::Colorant=colorant"black";
    canvas_width::Int = 1000,
    canvas_height::Int = 600,
    render_pos_overlay::Bool = false,
    reward::Float64=NaN,
    )

    s, ctx = get_canvas_and_context(canvas_width, canvas_height, camera_zoom=canvas_height/2)
    render_terrain!(ctx)
    render_mountain_car!(ctx, car, color)
    if render_pos_overlay
        render_position_overlay!(ctx, car, color)
    end
    if !isnan(reward)
        render_reward!(ctx, reward, color)
    end
    s
end