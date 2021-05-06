describe("Basic kibana is ", function () {
  it("Check kibana is accessible", function () {
    cy.visit("https://kibana.bigbang.dev:5601/login?next=%2F");
    cy.title().should("eq", "Elastic");

   /* cy.get("input[name=username]", { timeout: 15000 })
      .should("be.visible")
      .type("elastic")
      .should("have.value", "elastic");
    cy.get("input[name=password]", { timeout: 15000 })
      .should("be.visible")
      .type("7hc8Q47mp2hROO4Luh9w6i41");
    cy.get("form").submit();
    Cypress.on("uncaught:exception", (err, runnable) => {
      // returning false here prevents Cypress from
      // failing the test
      return false;
    });
    // Verify the app redirected you to the homepage
    cy.location("pathname", { timeout: 10000 }).should("eq", "/app/home");
    //cy.contains("Try our sample data", { timeout: 15000 }) .click();
    cy.get("button.euiHeaderSectionItem__button", { timeout: 15000 })
      .first()
      .click();
    cy.contains("Discover", { timeout: 15000 }).click();
    cy.title().should("eq", "Index patterns - Elastic"); */
  });
});
