class CreateViewingPartyUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :viewing_party_users do |t|

      t.timestamps
    end
  end
end
