import { ComponentFixture, TestBed } from '@angular/core/testing';

import { AwaitPaymentsComponent } from './await-payments.component';

describe('AwaitPaymentsComponent', () => {
  let component: AwaitPaymentsComponent;
  let fixture: ComponentFixture<AwaitPaymentsComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [AwaitPaymentsComponent]
    })
      .compileComponents();

    fixture = TestBed.createComponent(AwaitPaymentsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
