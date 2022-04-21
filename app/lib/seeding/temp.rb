# frozen_string_literal: true

def lots_of_logging
  log("hi")
  log("hi")
  log("hi")
  Rails.logger.info("fuck")
  Rails.logger.debug("fuck")
  Rails.logger.fatal("fuck")
end

def herestuff
  log(<<~MSG)
    Hello world
    Hello world
    Hello world
  MSG
end

def myhash
  {
    a: 1,
    b: 2,
    c: 3,
  }
end
