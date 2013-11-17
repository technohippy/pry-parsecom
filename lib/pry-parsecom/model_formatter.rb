module Parse
  class Object
    def to_s
      to_h.to_yaml
    end
  end
end
