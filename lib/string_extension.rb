class String
  def date?
      return Date.parse(self)
    rescue
      return nil
  end
end

