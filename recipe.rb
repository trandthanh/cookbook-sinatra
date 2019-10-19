class Recipe
  attr_accessor :name, :description, :prep_time, :done, :difficulty

  # def initialize(name, description)
  #   @name = name
  #   @description = description
  # end

  def initialize(attributes = {})
    @name = attributes[:name]
    @description = attributes[:description]
    @prep_time = attributes[:prep_time]
    @done = attributes[:done] || false
    @difficulty = attributes[:difficulty]
  end

  def done?
    @done
  end

  def done!
    @done = true
  end
end
