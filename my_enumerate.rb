module Enumerable

  def my_each
    if block_given?
      i = 0
      arr = self.to_a
      while i < arr.size
        yield arr[i]
        i += 1
      end
    else
      self.to_enum
    end
  end

  def my_each_with_index
    if block_given?
      i = 0
      self.my_each do |e|
        yield e, i
        i += 1
      end
    else
      self.to_enum
    end
  end

  def my_select
    new_arr = []
    if block_given?
      self.my_each do |e|
        new_arr << e if yield e
      end
      new_arr
    else
      self.to_enum
    end
  end

  def my_all?
    status = false
    self.my_each do |e|
      if block_given?
        unless yield e
          status = false
          break
        end
      elsif e
        status = true
        break
      end
    end
    status
  end

  def my_any?
    status = false
    self.my_each do |e|
      if block_given?
        if yield e
          status = true
          break
        end
      elsif e
        status = true
        break
      end
    end
    status
  end

  def my_none?
    status = true
    self.my_each do |e|
      if block_given?
        if yield e
          status = false
          break
        end
      elsif e
        status = false
        break
      end
    end
    status
  end

  def my_count(num=nil)
    counter = 0
    self.my_each do |i|
      if not block_given? and num == nil
        counter += 1
      elsif not block_given? and num != nil
        counter += 1 if i == num
      elsif block_given?
        counter += 1 if yield i
      end
    end
    counter
  end

  def my_map(proc=nil)
    new_arr = []
    if proc and block_given?
      self.my_each do |i|
        new_arr.push(yield proc.call(i))
      end
      return new_arr
    elsif proc
      self.my_each do |i|
        new_arr.push(proc.call(i))
      end
      return new_arr
    elsif block_given?
      self.my_each do |i|
        p = yield i
        new_arr.push(p)
      end
      return new_arr
    else
      self.to_enum
    end
  end

  def my_inject(*args)
    unless block_given?
      if args.size == 1
        obj = 0
        sum = 0
        action = args[0]
        self.my_each do |i|
          obj = i.send(action, obj)
          sum += obj
        end
      elsif args.size == 2
        obj = args[0]
        sum = 0
        action = args[1]
        self.my_each do |i|
          obj = i.send(action, obj)
          sum += obj
        end
      end
    end
    if block_given?
      if init == nil
        obj = 0
        sum = 0
        self.my_each do |i|
          puts obj
          obj = yield obj, i
          puts obj
          sum += obj
        end
      else
        obj = init
        sum = 0
        self.my_each do |i|
          puts obj
          obj = yield obj, i
          puts obj
          sum += obj
        end
      end
    end
    obj
  end

  #def multiply_els(arr)
   # arr.my_inject(1) {|p,q| p*q}
  #end
end



