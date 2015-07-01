module Attachable
  extend ActiveSupport::Concern

  included do
    has_many :attachments, dependent: :destroy, as: :attachable
  end
end