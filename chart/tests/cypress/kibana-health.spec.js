describe("Log in and look for logs in Kibana", function () {
  // required otherwise the tests will error out immediately when it sees there isn't an
  // active session
  Cypress.on('uncaught:exception', (err, runnable) => {
    return false
  })
  function kibana_login () {
    cy.wait(14000)
    cy.visit(Cypress.env('kibana_url'))
    cy.title().should("eq", "Elastic")
    cy.get('input[name="username"]', { timeout: 30000 })
      .type("elastic")
    cy.get('input[name="password"]').type(Cypress.env('elastic_password'))
    cy.get('button[type="submit"]').click()
    cy.location("pathname", { timeout: 10000 }).should("eq", "/app/home")
    cy.task('log', 'successfully logged in...')
    }
  // save the cookies in order to have multiple tests with one login
  beforeEach(function () {
    cy.getCookies().then(cookies => {
      const namesOfCookies = cookies.map(cm => cm.name)
      Cypress.Cookies.preserveOnce(...namesOfCookies)
    })
  })
  before(function () {
    kibana_login() 
  })
  it("Log into Kibana", function () {
    // note: all of the work is being done by the before function, which is in turn
    // done by kibana_login()
    cy.contains('Welcome to Elastic')
  })
  if (Cypress.env("expect_logs")) {
    it( "Check for logs", function () {
      cy.task('log', 'checking for logs in kibana...')
      cy.visit(Cypress.env('kibana_url') + '/app/management/data/index_management/indices', { timeout: 90000 })
      cy.get('th.euiTableRowCell', { timeout: 90000 }).its('length').should('be.gte', 1)
      cy.task('log', 'log entries detected...')
    })
  }
})
