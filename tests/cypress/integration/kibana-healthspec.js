describe('Basic kibana is ', function() {
  it('Check kibana is accessible', function() {
      cy.visit('http://elasticsearch-kibana-kb-http:5601')
      cy.title().should('eq', 'Elastic')

  })
})