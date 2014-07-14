require "delimr/version"
require "continuation"

module DelimR
  class Hole
    attr_accessor :ref, :marked
    def initialize(ref, marked)
      @ref = ref
      @marked = marked
    end
  end
  
  # I don't understand the semantics of these yet, but according to Oleg Kiselyov, they capture all four F operators.
  # I don't yet grok the differences between reset/shift and prompt/control
  @@is_shift = true
  @@keep_delimiter_upon_effect = true

  @@holes = []

  def self.prompt(&block)
    callcc do |outer_k|
      @@holes.push Hole.new(outer_k, true)
      abort_top(yield)
    end
  end

  def self.control(&block)
    callcc do |k_control|
      holes_prefix = unwind_till_marked || []
      holes_prefix.reverse
      invoke_subcont = lambda { |v| #What is v here?  
        callcc do |k_return|
          @@holes.push Hole.new(k_return, @@is_shift)
          holes_prefix.each { |h| @@holes.push(h) }
          k_control.call(v)
        end
      }
      abort_top(yield(invoke_subcont))
    end
  end

  module_function
  def abort_top(v)
    @@holes.pop.ref.call(v)
  end


  def unwind_till_marked
    if @@holes.empty?
      raise "No prompt set"
    end
    result = []
    while !@@holes.empty? && !@@holes.last.marked
      result << @@holes.pop
    end
    unless @@keep_delimiter_upon_effect
      @@holes.last = Hole.new(hole.ref, false)
    end
  end

  
end
