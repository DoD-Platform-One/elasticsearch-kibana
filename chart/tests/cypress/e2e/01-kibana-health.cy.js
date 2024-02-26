Cypress.on("uncaught:exception", (err, runnable) => {
  return false;
});

function kibana_login() {
  cy.visit(Cypress.env("kibana_url") + "/login", { timeout: 90000 });
  cy.title().should("eq", "Elastic");
  cy.get('input[name="username"]')
    .type("elastic");
  cy.get('input[name="password"]').type(Cypress.env("elastic_password"));
  cy.get('button[type="submit"]').click();
  cy.location("pathname", { timeout: 10000 }).should("eq", "/app/home");
}

beforeEach(() => {
  cy.session('loginUser', () => {
    kibana_login()
  },
    {
      cacheAcrossSpecs: true
    })
}) 

describe("Check Login And Home Page", () => {
  it("Check Home Page",
    {
      retries: {
        runMode: 89,
      },
    },
    () => {   
      cy.visit(Cypress.env("kibana_url") + "/app/home", { timeout: 30000 });
      // In Package pipelines, no configurations are passed so matches on "Welcome to Elastic" while in BB, configurations change the langing page to "Welcome Home"
      cy.contains(/Welcome to Elastic|Welcome home/g);
    });
})

describe("Check Indices", () => {

  if (Cypress.env("expect_logs")) {
    it("Check for existing indices",
    {
      retries: {
        runMode: 89,
      },
    },
    () => { 
      cy.visit(Cypress.env("kibana_url") + "/app/management/data/index_management/indices", {
        timeout: 30000,
      });
      cy.get("th.euiTableRowCell", { timeout: 10000 }).its("length").should("be.gte", 1);
    });
  }
});
