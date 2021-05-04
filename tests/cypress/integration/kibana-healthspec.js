describe('Basic kibana is ', function() {
  it('Check kibana is accessible', function() {
      cy.visit('kibana.bigbang.dev'')
      cy.title().should('eq', 'Elastic')

  })
})