module SubtasksInherited
  module IssuePatch
    module InstanceMethods

      # Returns a link for adding a new subtask to the given issue
      def check_sub_tasks
        if self.status_id_changed? and self.closed?
          # self.self_and_descendants.each do |issue|
          #   issue.status_id = self.status_id
          #   issue.save
          # end

            self.update_children_to_closed(self.status_id)

          end
      end

        def update_children_to_closed(status)
          self.children.each do |i|
            i.update_children_to_closed(status)
            i.update(status_id: status )
          end
        end
    end

    def self.included(receiver)
      receiver.send :include, InstanceMethods

      receiver.class_eval do
        unloadable
        after_update :check_sub_tasks
      end
    end
  end
end

unless Issue.included_modules.include?(SubtasksInherited::IssuePatch)
  #puts "Including module into IssuesHelper"
  Issue.send(:include, SubtasksInherited::IssuePatch)
end
