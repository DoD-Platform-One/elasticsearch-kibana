describe("Log in and look for logs in Kibana", function () {
  Cypress.on("uncaught:exception", (err, runnable) => {
    return false;
  });

  before(function () {
    // Perform the login before each test
    kibana_login();
  });

  function kibana_login() {
    cy.wait(4000);
    cy.visit(Cypress.env("kibana_url"));
    cy.title().should("eq", "Elastic");
    cy.get('input[name="username"]', { timeout: 30000 })
      .type("elastic");
    cy.get('input[name="password"]').type(Cypress.env("elastic_password"));
    cy.get('button[type="submit"]').click();
    cy.location("pathname", { timeout: 10000 }).should("eq", "/app/home");
    cy.wait(10000);
    // In Package pipelines, no configurations are passed so matches on "Welcome to Elastic" while in BB, configurations change the langing page to "Welcome Home"
    cy.contains(/Welcome to Elastic|Welcome home/g);
  }

  it("Log into Kibana", function () {
    // In Package pipelines, no configurations are passed so matches on "Welcome to Elastic" while in BB, configurations change the langing page to "Welcome Home"
    cy.contains(/Welcome to Elastic|Welcome home/g);
  });

  if (Cypress.env("expect_logs")) {
    it("Check for logs", function () {
      cy.visit(Cypress.env("kibana_url") + "/app/management/data/index_management/indices", {
        timeout: 90000,
      });
      cy.get("th.euiTableRowCell", { timeout: 90000 }).its("length").should("be.gte", 1);
    });
  }
});
