# frozen_string_literal: true

class Users::Update
  include Dry::Monads[:result, :do]

  USER_UPDATE_SCHEMA = Dry::Schema.Params do
    required(:id).filled(:integer)
    required(:nickname).filled(:string)
    required(:color).filled(:string)
    required(:avatar).filled(:any)
  end

  def call(input)
    params = yield validate(input)
    user = yield fetch_user(params)
    update(user: user, input: params)
  end

  private

  def validate(input)
    result = USER_UPDATE_SCHEMA.call(input)
    if result.success?
      Success(result.to_h)
    else
      Failure(message: result.errors.to_h, status: 422)
    end
  end

  def fetch_user(input)
    user = User.find_by(id: input.delete(:id))
    if user
      Success(user)
    else
      Failure(message: 'user not found')
    end
  end

  def update(user:, input:)
    avatar = input.delete(:avatar)
    user.assign_attributes(input)
    user.avatar.attach(avatar) if avatar.present? && avatar != 'null'

    if user.save
      Success(user)
    else
      Failure(message: user.errors.to_h)
    end
  end
end
