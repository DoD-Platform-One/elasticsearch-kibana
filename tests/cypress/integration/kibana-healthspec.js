describe('Basic ArgocD', function() {
  it('Check ArgoCD is accessible', function() {
      cy.visit(Cypress.env('kibana_url'))
      cy.title().should('eq', 'Elastic')

  })
})