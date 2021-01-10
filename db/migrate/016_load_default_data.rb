class LoadDefaultData < ActiveRecord::Migration[5.2]
  def up
    if Redmine::DefaultData::Loader::no_data?
      Redmine::DefaultData::Loader::load(lang = 'ja')
    end
  end
end
