class AddUserToViewingPartyUsers < ActiveRecord::Migration[7.1]
  def change
    add_reference :viewing_party_users, :user, null: false, foreign_key: true
  end
end
