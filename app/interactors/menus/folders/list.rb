# frozen_string_literal: true

class Menus::Folders::List
  include Dry::Monads[:result, :do]

  ITEMS_LIST_SCHEMA = Dry::Schema.Params do
    required(:user_id).filled(:integer)
    required(:menu_id).filled(:integer)
  end

  def call(input)
    params = yield validate(input)
    user = yield fetch_user(params)
    menu = yield fetch_menu(params)
    policy = Menus::ItemPolicy.new(user: user)
    folders_with_items(user: user, menu: menu, policy: policy)
  end

  private

  def validate(input)
    result = ITEMS_LIST_SCHEMA.call(input)
    if result.success?
      Success(result.to_h)
    else
      Failure(message: result.errors.to_h, status: 422)
    end
  end

  def fetch_user(input)
    user = User.find(input[:user_id])
    if user
      Success(user)
    else
      Failure(message: 'user not found', status: :not_fount)
    end
  end

  def fetch_menu(input)
    menu = Menu.find(input[:menu_id])
    if menu
      Success(menu)
    else
      Failure(message: 'menu not found', status: :not_fount)
    end
  end

  def folders_with_items(user:, menu:, policy:)
    root = menu.folders.root
    options = { scope_options: { game: menu.game }, type: :active_record_relation }
    folders = items_in_folder(folder: root, user: user, policy: policy, options: options)
    folders = root.folder_struct(items: [], children: []) if folders.is_a? Array

    Success(folders)
  end

  def items_in_folder(folder:, user:, policy:, options:)
    items = policy.apply_scope(folder.items.order(created_at: :desc), **options)

    children = folder.children
    children_list = []
    children.each do |child|
      children_list << items_in_folder(folder: child, user: user, policy: policy, options: options)
    end

    folder.folder_struct(items: items, children: children_list)
  end
end
