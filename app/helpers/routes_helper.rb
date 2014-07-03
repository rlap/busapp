module RoutesHelper

  def direction_value1(route)
    if Route::EAST_WEST_START1.include? route.name
      1
    else
      2
    end
  end

  def direction_value2(route)
    if direction_value1(route) == 1
      2
    else
      1
    end
  end

end
