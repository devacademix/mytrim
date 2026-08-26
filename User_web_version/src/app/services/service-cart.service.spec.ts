import { TestBed } from '@angular/core/testing';

import { ServiceCartService } from './service-cart.service';

describe('ServiceCartService', () => {
  let service: ServiceCartService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(ServiceCartService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
