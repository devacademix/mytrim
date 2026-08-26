import { ComponentFixture, TestBed } from '@angular/core/testing';

import { TopFreelancersComponent } from './top-freelancers.component';

describe('TopFreelancersComponent', () => {
  let component: TopFreelancersComponent;
  let fixture: ComponentFixture<TopFreelancersComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [TopFreelancersComponent]
    })
      .compileComponents();

    fixture = TestBed.createComponent(TopFreelancersComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
