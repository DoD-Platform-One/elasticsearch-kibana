describe("Basic Kibana", function () {
  it("Check Kibana UI is accessible", function () {
    cy.visit(Cypress.env('kibana_url'))
    cy.title().should("eq", "Elastic")
    cy.wait(10000)
    cy.get('input[name="username"]', { timeout: 15000 })
      .type("elastic")
    cy.get('input[name="password"]').type(Cypress.env('elastic_password'))
    cy.get('button[type="submit"]').click();

    // Verify the app redirected you to the homepage
    cy.location("pathname", { timeout: 10000 }).should("eq", "/app/home");

    cy.contains("Add sample data", { timeout: 15000 })
      .should("be.visible")
      .click();
    cy.get("button.euiHeaderSectionItem__button", { timeout: 15000 })
      .first()
      .click();
    cy.get('button[title="Discover"]', { timeout: 15000 }).click();
    cy.title().should("eq", "Discover - Elastic");
  });
});
