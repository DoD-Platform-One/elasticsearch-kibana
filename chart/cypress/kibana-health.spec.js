describe('Basic Kibana', function() {
  it('Check Kibana UI is accessible', function() {
    

    cy.visit( Cypress.env('kibana_url') 
    cy.title().should('eq', 'Elastic')
    
    
  })
})
