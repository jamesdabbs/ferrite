module Slack
  class TeamPolicy < ApplicationPolicy
    def create?
      user.instructor?
    end

    class Scope < Scope
      def resolve
        if user.student?
          raise NotImplementedError
        else
          scope.all
        end
      end
    end
  end
end
