describe("Log in and look for logs in Kibana", function () {
  Cypress.on("uncaught:exception", (err, runnable) => {
    return false;
  });

  beforeEach(function () {
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
    cy.contains("Welcome to Elastic");
  }

  it("Log into Kibana", function () {
    cy.contains("Welcome to Elastic");
  });

  if (Cypress.env("expect_logs")) {
    it("Check for logs", function () {
      cy.task("log", "checking for logs in Kibana...");
      cy.visit(Cypress.env("kibana_url") + "/app/management/data/index_management/indices", {
        timeout: 90000,
      });
      cy.get("th.euiTableRowCell", { timeout: 90000 }).its("length").should("be.gte", 1);
      cy.task("log", "log entries detected...");
    });
  }
});
