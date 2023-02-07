module PowerTypes
  module Util
    OBSERVABLE_EVENTS = [:create, :update, :save, :destroy]
    OBSERVABLE_TRANSACTIONAL_EVENTS = [:create_commit, :update_commit, :save_commit,
                                       :destroy_commit]
    OBSERVABLE_TYPES = [:before, :after]
  end
end
