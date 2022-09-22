<h1>Bulk Discount</h2>

<p>This project is an extension of the Little Esty Shop group project. You will add functionality for merchants to create bulk discounts for their items. A “bulk discount” is a discount based on the quantity of items the customer is buying, for example “20% off orders of 10 or more items”.</p>

<h2 id="learning-goals">Learning Goals</h2>

<ul>
  <li>Write migrations to create tables and relationships between tables</li>
  <li>Implement CRUD functionality for a resource using forms (form_tag or form_with), buttons, and links</li>
  <li>Use MVC to organize code effectively, limiting the amount of logic included in views and controllers</li>
  <li>Use built-in ActiveRecord methods to join multiple tables of data, make calculations, and group data based on one or more attributes</li>
  <li>Write model tests that fully cover the data logic of the application</li>
  <li>Write feature tests that fully cover the functionality of the application</li>
</ul>

<h2 id="deets">Deets</h2>

<ul>
  <li>This is a solo project, to be completed alone without assistance from cohortmates, alumni, mentors, rocks, etc.</li>
  <li>Additional gems to be added to the project must have instructor approval. (RSpec, Capybara, Shoulda-Matchers, Orderly, HTTParty, Launchy, Faker are pre-approved)</li>
  <li>Scaffolding is not permitted on this project.</li>
  <li>This project must be deployed to Heroku.</li>
</ul>

<h2 id="setup">Setup</h2>

<p>This project is an extension of Little Esty Shop. Students have two options for setup:</p>

<ol>
  <li>If your Little Esty Shop project is complete, you can use it as a starting point for this project. If you are not the repo owner, fork the project to your account. If you are the repo owner, you can work off the repo without forking, just make sure your teammates have a chance to fork before pushing any commits to your repo</li>
  <li>If your Little Esty Shop project is not complete, fork <a href="https://github.com/turingschool-examples/little_esty_shop_bulk_discounts">this repo</a> as a starting point for this project.</li>
  <li>Scaffolding is not permitted for this project.</li>
  <li>Additional gems for this project needs to be approved by instructors.</li>
</ol>

<h2 id="rubric">Rubric</h2>

<table>
  <thead>
    <tr>
      <th> </th>
      <th><strong>Feature Completeness</strong></th>
      <th><strong>Rails</strong></th>
      <th><strong>ActiveRecord</strong></th>
      <th><strong>Testing and Debugging</strong></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><strong>4: Exceptional</strong></td>
      <td>One or more additional extension features complete.</td>
      <td>Students implement strategies not discussed in class and can defend their design decisions (callbacks, scopes, application_helper view methods are created, etc)</td>
      <td>ActiveRecord helpers are utilized whenever possible. ActiveRecord is used in a clear and effective way to read/write data including use of grouping, aggregating, and joining. Very little Ruby is used to process data.</td>
      <td>Very clear Test Driven Development. Test files are extremely well organized and nested. Students can point to multiple examples of edge case testing that are not included in the user stories.</td>
    </tr>
    <tr>
      <td><strong>3: Passing</strong></td>
      <td>Bulk discount is 100% complete</td>
      <td>Students use the principles of MVC to effectively organize code with only 1 - 2 infractions. Routes and Actions mostly follow RESTful conventions</td>
      <td>ActiveRecord helpers are utilized most of the time. ActiveRecord grouping, aggregating, and joining is used to process data at least once.  Queries are functional and accurate.</td>
      <td>100% coverage for models. 98% coverage for features. Tests are well written and meaningful. All tests passing. TDD Process is clear throughout commits. Some sad path and edge case testing. Tests utilize within blocks to target specific areas of a page.</td>
    </tr>
    <tr>
      <td><strong>2: Passing with Concerns</strong></td>
      <td>One to two of the completion criteria for Bulk Discount features are not complete</td>
      <td>Students utilize MVC to organize code, but cannot defend some of their design decisions. 3 or more infractions are present. RESTful conventions are only sometimes followed.</td>
      <td>Ruby is used to process data that could use ActiveRecord instead. Some instances where ActiveRecord helpers are not utilized. Some queries not accurately implemented.</td>
      <td>Feature test coverage between 90% and 98%, or model test coverage below 100%, or tests are not meaningfully written or have an unclear objective, or tests do not utilize within blocks. Missing sad path or edge case testing.</td>
    </tr>
    <tr>
      <td><strong>1: Failing</strong></td>
      <td>More than two of the completion criteria for Bulk Discount feature is incomplete</td>
      <td>Students do not effectively organize code using MVC.</td>
      <td>Ruby is used to process data more often than ActiveRecord. Many cases where ActiveRecord helpers are not utilized.</td>
      <td>Below 90% coverage for either features or models. TDD was not used.</td>
    </tr>
  </tbody>
</table>

<h2 id="bulk-discounts-1">Bulk Discounts</h2>

<p>Bulk Discounts are subject to the following criteria:</p>

<ul>
  <li>Bulk discounts should have a percentage discount as well as a quantity threshold</li>
  <li>Bulk discounts should belong to a Merchant</li>
  <li>A Bulk discount is eligible for all items that the merchant sells. Bulk discounts for one merchant should not affect items sold by another merchant</li>
  <li>Merchants can have multiple bulk discounts
    <ul>
      <li>If an item meets the quantity threshold for multiple bulk discounts, only the one with the greatest percentage discount should be applied</li>
    </ul>
  </li>
  <li>Bulk discounts should apply on a per-item basis
    <ul>
      <li>If the quantity of an item ordered meets or exceeds the quantity threshold, then the percentage discount should apply to that item only. Other items that did not meet the quantity threshold will not be affected.</li>
      <li>The quantities of items ordered cannot be added together to meet the quantity thresholds, e.g. a customer cannot order 1 of Item A and 1 of Item B to meet a quantity threshold of 2. They must order 2 or Item A and/or 2 of Item B</li>
    </ul>
  </li>
</ul>

<h3 id="examples">Examples</h3>

<p><strong>Example 1</strong></p>

<ul>
  <li>Merchant A has one Bulk Discount
    <ul>
      <li>Bulk Discount A is 20% off 10 items</li>
    </ul>
  </li>
  <li>Invoice A includes two of Merchant A’s items
    <ul>
      <li>Item A is ordered in a quantity of 5</li>
      <li>Item B is ordered in a quantity of 5</li>
    </ul>
  </li>
</ul>

<p>In this example, no bulk discounts should be applied.</p>

<p><strong>Example 2</strong></p>

<ul>
  <li>Merchant A has one Bulk Discount
    <ul>
      <li>Bulk Discount A is 20% off 10 items</li>
    </ul>
  </li>
  <li>Invoice A includes two of Merchant A’s items
    <ul>
      <li>Item A is ordered in a quantity of 10</li>
      <li>Item B is ordered in a quantity of 5</li>
    </ul>
  </li>
</ul>

<p>In this example, Item A should be discounted at 20% off. Item B should not be discounted.</p>

<p><strong>Example 3</strong></p>

<ul>
  <li>Merchant A has two Bulk Discounts
    <ul>
      <li>Bulk Discount A is 20% off 10 items</li>
      <li>Bulk Discount B is 30% off 15 items</li>
    </ul>
  </li>
  <li>Invoice A includes two of Merchant A’s items
    <ul>
      <li>Item A is ordered in a quantity of 12</li>
      <li>Item B is ordered in a quantity of 15</li>
    </ul>
  </li>
</ul>

<p>In this example, Item A should discounted at 20% off, and Item B should discounted at 30% off.</p>

<p><strong>Example 4</strong></p>

<ul>
  <li>Merchant A has two Bulk Discounts
    <ul>
      <li>Bulk Discount A is 20% off 10 items</li>
      <li>Bulk Discount B is 15% off 15 items</li>
    </ul>
  </li>
  <li>Invoice A includes two of Merchant A’s items
    <ul>
      <li>Item A is ordered in a quantity of 12</li>
      <li>Item B is ordered in a quantity of 15</li>
    </ul>
  </li>
</ul>

<p>In this example, Both Item A and Item B should discounted at 20% off. Additionally, there is no scenario where Bulk Discount B can ever be applied.</p>

<p><strong>Example 5</strong></p>

<ul>
  <li>Merchant A has two Bulk Discounts
    <ul>
      <li>Bulk Discount A is 20% off 10 items</li>
      <li>Bulk Discount B is 30% off 15 items</li>
    </ul>
  </li>
  <li>Merchant B has no Bulk Discounts</li>
  <li>Invoice A includes two of Merchant A’s items
    <ul>
      <li>Item A1 is ordered in a quantity of 12</li>
      <li>Item A2 is ordered in a quantity of 15</li>
    </ul>
  </li>
  <li>Invoice A also includes one of Merchant B’s items
    <ul>
      <li>Item B is ordered in a quantity of 15</li>
    </ul>
  </li>
</ul>

<p>In this example, Item A1 should discounted at 20% off, and Item A2 should discounted at 30% off. Item B should not be discounted.</p>

<h2 id="user-stories">User Stories</h2>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>Merchant Bulk Discounts Index

As a merchant
When I visit my merchant dashboard
Then I see a link to view all my discounts
When I click this link
Then I am taken to my bulk discounts index page
Where I see all of my bulk discounts including their
percentage discount and quantity thresholds
And each bulk discount listed includes a link to its show page
</code></pre></div></div>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>Merchant Bulk Discount Create

As a merchant
When I visit my bulk discounts index
Then I see a link to create a new discount
When I click this link
Then I am taken to a new page where I see a form to add a new bulk discount
When I fill in the form with valid data
Then I am redirected back to the bulk discount index
And I see my new bulk discount listed
</code></pre></div></div>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>Merchant Bulk Discount Delete

As a merchant
When I visit my bulk discounts index
Then next to each bulk discount I see a link to delete it
When I click this link
Then I am redirected back to the bulk discounts index page
And I no longer see the discount listed
</code></pre></div></div>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>Merchant Bulk Discount Show

As a merchant
When I visit my bulk discount show page
Then I see the bulk discount's quantity threshold and percentage discount
</code></pre></div></div>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>Merchant Bulk Discount Edit

As a merchant
When I visit my bulk discount show page
Then I see a link to edit the bulk discount
When I click this link
Then I am taken to a new page with a form to edit the discount
And I see that the discounts current attributes are pre-poluated in the form
When I change any/all of the information and click submit
Then I am redirected to the bulk discount's show page
And I see that the discount's attributes have been updated
</code></pre></div></div>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>Merchant Invoice Show Page: Total Revenue and Discounted Revenue

As a merchant
When I visit my merchant invoice show page
Then I see the total revenue for my merchant from this invoice (not including discounts)
And I see the total discounted revenue for my merchant from this invoice which includes bulk discounts in the calculation
</code></pre></div></div>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>Merchant Invoice Show Page: Link to applied discounts

As a merchant
When I visit my merchant invoice show page
Next to each invoice item I see a link to the show page for the bulk discount that was applied (if any)
</code></pre></div></div>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>Admin Invoice Show Page: Total Revenue and Discounted Revenue

As an admin
When I visit an admin invoice show page
Then I see the total revenue from this invoice (not including discounts)
And I see the total discounted revenue from this invoice which includes bulk discounts in the calculation
</code></pre></div></div>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>As a merchant
When I visit the discounts index page
I see a section with a header of "Upcoming Holidays"
In this section the name and date of the next 3 upcoming US holidays are listed.

Use the Next Public Holidays Endpoint in the [Nager.Date API](https://date.nager.at/swagger/index.html)

</code></pre></div></div>

<h2 id="extensions">Extensions</h2>

<ul>
  <li>When an invoice is pending, a merchant should not be able to delete or edit a bulk discount that applies to any of their items on that invoice.</li>
  <li>When an Admin marks an invoice as “completed”, then the discount percentage should be stored on the invoice item record so that it can be referenced later</li>
  <li>Merchants should not be able to create/edit bulk discounts if they already have a discount in the system that would prevent the new discount from being applied (see example 4)</li>
  <li>Holiday Discount Extensions</li>
</ul>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>Create a Holiday Discount

As a merchant,
when I visit the discounts index page,
In the Holiday Discounts section, I see a `create discount` button next to each of the 3 upcoming holidays.
When I click on the button I am taken to a new discount form that has the form fields auto populated with the following:

Discount name: &lt;name of holiday&gt; discount
Percentage Discount: 30
Quantity Threshold: 2

I can leave the information as is, or modify it before saving.
I should be redirected to the discounts index page where I see the newly created discount added to the list of discounts.
</code></pre></div></div>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>View a Holiday Discount

As a merchant (if I have created a holiday discount for a specific holiday),
when I visit the discount index page,
within the `Upcoming Holidays` section I should not see the button to 'create a discount' next to that holiday,
instead I should see a `view discount` link.
When I click the link I am taken to the discount show page for that holiday discount.
</code></pre></div></div>
