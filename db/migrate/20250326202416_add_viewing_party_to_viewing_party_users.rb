class AddViewingPartyToViewingPartyUsers < ActiveRecord::Migration[7.1]
  def change
    add_reference :viewing_party_users, :viewing_party, null: false, foreign_key: true
  end
end
