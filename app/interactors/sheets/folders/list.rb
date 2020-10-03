# frozen_string_literal: true

class Sheets::Folders::List
  include Dry::Monads[:result, :do]

  SHEETS_LIST_SCHEMA = Dry::Schema.Params do
    required(:user_id).filled(:integer)
    required(:game_id).filled(:integer)
  end

  def call(input)
    params = yield validate(input)
    user = yield fetch_user(params)
    game = yield fetch_game(params)
    policy = SheetPolicy.new(user: user)
    folders_with_sheets(user: user, game: game, policy: policy)
  end

  private

  def validate(input)
    result = SHEETS_LIST_SCHEMA.call(input)
    if result.success?
      Success(result.to_h)
    else
      Failure(message: result.errors.to_h, status: 422)
    end
  end

  def fetch_user(input)
    user = User.find_by(id: input[:user_id])
    if user
      Success(user)
    else
      Failure(message: 'user not found', status: :not_fount)
    end
  end

  def fetch_game(input)
    menu = Game.find_by(id: input[:game_id])
    if menu
      Success(menu)
    else
      Failure(message: 'game not found', status: :not_fount)
    end
  end

  def folders_with_sheets(user:, game:, policy:)
    root = game.folders.root
    options = { scope_options: { game: game }, type: :active_record_relation }
    folders = sheets_in_folder(folder: root, user: user, policy: policy, options: options)
    folders = root.folder_struct(sheets: [], children: []) if folders.is_a? Array

    Success(folders)
  end

  def sheets_in_folder(folder:, user:, policy:, options:)
    sheets = policy.apply_scope(folder.sheets.order(created_at: :desc), **options)

    children = folder.children
    children_list = []
    children.each do |child|
      children_list << sheets_in_folder(folder: child, user: user, policy: policy, options: options)
    end

    folder.folder_struct(sheets: sheets, children: children_list)
  end
end
