describe('Basic Kibana', function() {
  it('Check Kibana UI is accessible', function() {
    cy.visit(Cypress.env('kibana_url'))
    cy.title().should('eq', 'Elastic')
    cy.get('[name="username"]')
        .type('elastic')
        .should('have.value', 'elastic');

      // Fill the password
      cy.get('[name="password"]')
        .type(Cypress.env('password'))
        .should('have.value', Cypress.env('password'));

      // Locate and submit the form
      cy.get('form').submit();
      
      // Verify the app redirected you to the homepage
      cy.location('pathname', { timeout: 10000 }).should('eq', '/app/home');
      
      // Verify the page title is "Home"
     cy.title().should('eq', 'Home - Elastic1');

  
  })
})
