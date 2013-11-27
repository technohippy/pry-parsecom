module Parse
  class Object
    def to_s
      to_h.to_yaml
    end

    def inspect
      to_s
    end
  end
end

class Array
  #alias_method :inspect_original, :inspect
  alias_method :inspect_original, :to_s
  #def inspect
  def to_s
    if self.empty? || self.all? {|e| e === Parse::Object}
puts self.first.class.name
      heads = self.first.to_h.keys
      table = PryParsecom::Table.new heads
      self.each do |e|
        table.add_row heads.map{|h| e[h]}
      end
      table.to_s
    else
puts :inspect_original
      inspect_original
    end
  end
end
