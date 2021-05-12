describe("Basic Kibana", function () {
  it("Check Kibana UI is accessible", function () {
    //cy.visit( 'https://elasticsearch-kibana-kb-http:5601/login?next=%2F')
    cy.visit(`${Cypress.env('kibana_url')}/login?next=%2F`);
    cy.title().should("eq", "Elastic");
    cy.get("input[name=username]", { timeout: 15000 })
      .should("be.visible")
      .type("elastic")
      .should("have.value", "elastic");
    cy.get("input[name=password]")
      .type(Cypress.env('elastic_password'))
      .should("have.value", Cypress.env("password"));

    cy.get("form").submit();
    Cypress.on("uncaught:exception", (err, runnable) => {
      // returning false here prevents Cypress from
      // failing the test
      return false;
    });

    // Verify the app redirected you to the homepage
    cy.location("pathname", { timeout: 10000 }).should("eq", "/app/home");

    /*cy.contains("Try our sample data", { timeout: 15000 })
      .should("be.visible")
      .click();
    cy.get("button.euiHeaderSectionItem__button", { timeout: 15000 })
      .first()
      .click();
    cy.contains("Discover", { timeout: 15000 }).click();
    cy.title().should("eq", "Index patterns - Elastic"); */
  });
});
