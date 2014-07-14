# DelimR

*For background information, see this [blog post](http://blog.ontoillogical.com/blog/2014/07/12/delimited-continuations-in-ruby/).*

Implements [delimited continuations](https://en.wikipedia.org/wiki/Delimited_continuation) in Ruby. This is a direct port of Oleg Kselyov's Scheme [implementation](http://okmij.org/ftp/continuations/implementations.html#delimcc-scheme).

This is an experiment. Ruby continuations are [considered harmful](http://www.atdot.net/~ko1/pub/ContinuationFest-ruby.pdf). By the way, I want to take a minute to point out that this talk was at something called "Continuation Fest 2008", and calls Matz out for being a "criminal."

TL;DR: Don't use this for anything "serious."

## Installation

Add this line to your application's Gemfile:

    gem 'delimr'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install delimr

## Usage

TODO: make this clearer

Delimited continuations can be a bit tricky. Basically, `DelimR.prompt` takes a block and marks the boundary of the continuation. Inside `DelimR.prompt`, you can call `DelimR.control` which takes a block with a single argument. That argument is a *function* which represents the rest of the computation around the `DelimR.control` block. The results of the `DelimR.control` block, or of calling the continuation, will be returned to where the `DelimR.prompt` was declared.

## Examples

```ruby
# k represents the computation outside of it
DelimR.prompt { 1 + DelimR.control { |k| k.call(3) } + 7}
# => 11

# If we don't call k, the computation is lost, and simply the value is returned
DelimR.prompt { 1 + DelimR.control { |k| 3 } + 7}
# => 3

# Delmited computations are composable! We can keep applying k to itself
DelimR.prompt { 1 + DelimR.control { |k| k.call(k.call(3)) } + 7}
# (1 + (1 + 3 + 7) + 7)
# => 19
```

## A more involved example

Back in 1.8.7, Ruby core had an implementation of generators using plain old continuations. You can see it [here](https://github.com/ruby/ruby/blob/ruby_1_8_7/lib/generator.rb).

Below, we implement Python style generators using delimited continuations.

```ruby
class Generator
  def initialize(&block)
    @results = []
    DelimR.prompt do
      block.call(self)
    end
  end
  
  def next
    r = @results.pop
    if r.nil?
      raise "Iterator finished"
    end
    @k.call(nil)
    r
  end
  
  def yield(result)
    @results << result
    DelimR.control do |k| 
      @k = k
    end
  end
end
```

and use it:

```ruby
counter = Generator.new do |g| 
  ctr = 0
  while true
    g.yield(ctr)
    ctr += 1
  end
end

counter.next
# => 0
counter.next
# => 1
counter.next
# => 2
# ...
```


For more information on delimited continuations

1. http://community.schemewiki.org/?composable-continuations-tutorial

## Contributing

1. Fork it ( https://github.com/[my-github-username]/delimr/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
