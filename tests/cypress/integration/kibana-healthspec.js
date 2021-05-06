describe('Basic kibana is ', function() {
  it('Check kibana is accessible', function() {
      cy.visit('kibana.bigbang.dev')
      cy.title().should('eq', 'Elastic')
      cy.get('[name="username"]')
      .type('elastic')
      .should('have.value', 'elastic');

  })
})