class Create<%= domain_model_class %>And<%= identity_model_class %> < ActiveRecord::Migration
  def change
    create_table(:<%= plural_domain_model %>) do |t|
      t.string :first_name
      t.string :last_name

      t.timestamps
    end

    create_table(:<%= plural_identity_model %>) do |t|
      t.string :email
      t.string :password_digest, null: false, default: ""
      t.references :<%= domain_model %>

      t.timestamps
    end

    add_index :<%= plural_identity_model %>, :email, unique: true
    add_index :<%= plural_identity_model %>, :<%= domain_model_id %>
  end
end
