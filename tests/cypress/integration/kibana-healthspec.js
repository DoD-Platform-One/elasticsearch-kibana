describe('Basic kibana is ', function() {
  it('Check kibana is accessible', function() {
      cy.visit(Cypress.env('kibana_url'))
      cy.title().should('eq', 'Elastic')

  })
})