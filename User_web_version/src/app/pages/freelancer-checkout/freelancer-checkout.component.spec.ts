import { ComponentFixture, TestBed } from '@angular/core/testing';

import { FreelancerCheckoutComponent } from './freelancer-checkout.component';

describe('FreelancerCheckoutComponent', () => {
  let component: FreelancerCheckoutComponent;
  let fixture: ComponentFixture<FreelancerCheckoutComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [FreelancerCheckoutComponent]
    })
      .compileComponents();

    fixture = TestBed.createComponent(FreelancerCheckoutComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
