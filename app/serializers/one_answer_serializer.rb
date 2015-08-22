class OneAnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at, :updated_at
  has_many :comments, :attachments
end