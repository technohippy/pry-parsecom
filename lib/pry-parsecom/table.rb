module PryPersecom
  class Table
    def initialize heads, rows=[]
      @heads = heads
      @rows = []
      @col_widths = Hash.new 0
      @heads.each do |head|
        @col_widths[head] = head.size
      end
    end

    def rows= rows
      @rows.clear
      rows.each do |row|
        add_row row
      end
    end

    def add_row row
      cols = []
      if row.is_a? Hash
        @heads.each do |head|
          cols << row[head]
        end
      end

      cols.each.with_index do |col, i|
        if @col_widths[i] < col.size
          @col_widths[i] = col.size
        end
      end
    end

    def to_s
      ret = @heads.map.with_index do |head, i|
        head.center @col_width[i]
      end.join " | "
      ret += "\n"
      ret += '=' * heads.size
      ret += "\n"
      @rows.each do |row|
        ret += row.map.with_index do |col, i|
          col.left @col_width[i]
        end.join " | "
        ret += "\n"
      end
      ret
    end
  end
end
