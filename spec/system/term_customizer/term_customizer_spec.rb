# frozen_string_literal: true

require "spec_helper"

describe "With term customizer module", type: :system do
  let(:user) { create(:user, :admin, :confirmed) }
  let(:organization) { user.organization }

  before do
    switch_to_host(organization.host)
    login_as user, scope: :user
    visit decidim_admin.root_path
  end

  it "shows the term customizer tab in the menu" do
    expect(page).to have_content("Term customizer")
  end

  it "shows a link to term customizer" do
    expect(page).to have_css('a[href="/admin/term_customizer/sets"')
  end

  context "when accessing to term customizer module" do
    before do
      click_link "Term customizer"
    end

    it "shows the translations sets" do
      within "div#translation_sets" do
        expect(page).to have_content("Translation sets")
        expect(page).to have_content("No translation sets available.")
        expect(page).to have_css('a[href="/admin/term_customizer/sets/new"')
        expect(page).to have_content("Clear cache")
        expect(page).to have_content("New translation set")
      end
    end

    context "when creating a new translation set" do
      before do
        within "div#translation_sets > div.card-divider" do
          click_link "New translation set"
        end
      end

      it "navigates to the translation set form" do
        expect(page).to have_current_path("/admin/term_customizer/sets/new")
      end

      it "allows to create a new set" do
        expect(page).to have_content("Name")
        fill_in "translation_set_name_en", with: "Dummy set"

        click_button "Create"
        expect(page).to have_content("Translation set successfully created")
        expect(page).to have_current_path(%r{/admin/term_customizer/sets/\d+/translations})
      end
    end

    context "when clearing cache" do
      before do
        click_link "Clear cache"
      end

      it "opens a confirmation modal" do
        expect(page).to have_css("div.small.reveal.confirm-reveal")
        expect(page).to have_content("Confirm delete")
      end

      it "clears cache on confirmation" do
        click_link "OK"

        expect(page).to have_content("Cache cleared successfully")
        expect(page).not_to have_content("Confirm delete")
      end

      it "doest not clear cache when canceled" do
        click_link "Cancel"

        expect(page).not_to have_content("Cache cleared successfully")
        expect(page).not_to have_content("Confirm delete")
      end
    end
  end
end
