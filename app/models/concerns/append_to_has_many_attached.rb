module AppendToHasManyAttached
  def self.[](fields)
    Module.new do
      extend ActiveSupport::Concern

      fields = Array(fields).compact_blank # will always return an array ( worst case is an empty array)

      fields.each do |field|
        field = field.to_s # We need the string version
        define_method :"#{field}=" do |attachables|
          attachables = Array(attachables).compact_blank

          if attachables.any?
            attachment_changes[field] =
              ActiveStorage::Attached::Changes::CreateMany.new(field, self, public_send(field).public_send(:blobs) + attachables)
          end
        end
      end
    end
  end
end